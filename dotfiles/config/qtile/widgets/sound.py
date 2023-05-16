
import curses
import functools
import getopt
import operator
import os
import re
import signal
import sys
import threading
import traceback
from collections import OrderedDict
from configparser import ConfigParser
from ctypes import *
from itertools import takewhile
from pprint import pprint
from select import select
from shutil import get_terminal_size
from textwrap import dedent
from time import sleep
from unicodedata import east_asian_width

#########################################################################################
# v bindings

try:
    DLL = CDLL("libpulse.so.0")
except Exception as e:
    sys.exit(e)

PA_VOLUME_NORM = 65536
PA_CHANNELS_MAX = 32
PA_USEC_T = c_uint64
PA_CONTEXT_READY = 4
PA_CONTEXT_FAILED = 5
PA_SUBSCRIPTION_MASK_ALL = 0x02ff


class Struct(Structure): pass
PA_PROPLIST = PA_OPERATION = PA_CONTEXT = PA_THREADED_MAINLOOP = PA_MAINLOOP_API = Struct


class PA_SAMPLE_SPEC(Structure):
    _fields_ = [
        ("format",      c_int),
        ("rate",        c_uint32),
        ("channels",    c_uint32)
    ]


class PA_CHANNEL_MAP(Structure):
    _fields_ = [
        ("channels",    c_uint8),
        ("map",         c_int * PA_CHANNELS_MAX)
    ]


class PA_CVOLUME(Structure):
    _fields_ = [
        ("channels",    c_uint8),
        ("values",      c_uint32 * PA_CHANNELS_MAX)
    ]


class PA_PORT_INFO(Structure):
    _fields_ = [
        ('name',        c_char_p),
        ('description', c_char_p),
        ('priority',    c_uint32),
        ("available",   c_int),
    ]


class PA_SINK_INPUT_INFO(Structure):
    _fields_ = [
        ("index",           c_uint32),
        ("name",            c_char_p),
        ("owner_module",    c_uint32),
        ("client",          c_uint32),
        ("sink",            c_uint32),
        ("sample_spec",     PA_SAMPLE_SPEC),
        ("channel_map",     PA_CHANNEL_MAP),
        ("volume",          PA_CVOLUME),
        ("buffer_usec",     PA_USEC_T),
        ("sink_usec",       PA_USEC_T),
        ("resample_method", c_char_p),
        ("driver",          c_char_p),
        ("mute",            c_int),
        ("proplist",        POINTER(PA_PROPLIST))
    ]


class PA_SINK_INFO(Structure):
    _fields_ = [
        ("name",                c_char_p),
        ("index",               c_uint32),
        ("description",         c_char_p),
        ("sample_spec",         PA_SAMPLE_SPEC),
        ("channel_map",         PA_CHANNEL_MAP),
        ("owner_module",        c_uint32),
        ("volume",              PA_CVOLUME),
        ("mute",                c_int),
        ("monitor_source",      c_uint32),
        ("monitor_source_name", c_char_p),
        ("latency",             PA_USEC_T),
        ("driver",              c_char_p),
        ("flags",               c_int),
        ("proplist",            POINTER(PA_PROPLIST)),
        ("configured_latency",  PA_USEC_T),
        ('base_volume',         c_int),
        ('state',               c_int),
        ('n_volume_steps',      c_int),
        ('card',                c_uint32),
        ('n_ports',             c_uint32),
        ('ports',               POINTER(POINTER(PA_PORT_INFO))),
        ('active_port',         POINTER(PA_PORT_INFO))
    ]


class PA_SOURCE_OUTPUT_INFO(Structure):
    _fields_ = [
        ("index",           c_uint32),
        ("name",            c_char_p),
        ("owner_module",    c_uint32),
        ("client",          c_uint32),
        ("source",          c_uint32),
        ("sample_spec",     PA_SAMPLE_SPEC),
        ("channel_map",     PA_CHANNEL_MAP),
        ("buffer_usec",     PA_USEC_T),
        ("source_usec",     PA_USEC_T),
        ("resample_method", c_char_p),
        ("driver",          c_char_p),
        ("proplist",        POINTER(PA_PROPLIST)),
        ("corked",          c_int),
        ("volume",          PA_CVOLUME),
        ("mute",            c_int),
    ]


class PA_SOURCE_INFO(Structure):
    _fields_ = [
        ("name",                 c_char_p),
        ("index",                c_uint32),
        ("description",          c_char_p),
        ("sample_spec",          PA_SAMPLE_SPEC),
        ("channel_map",          PA_CHANNEL_MAP),
        ("owner_module",         c_uint32),
        ("volume",               PA_CVOLUME),
        ("mute",                 c_int),
        ("monitor_of_sink",      c_uint32),
        ("monitor_of_sink_name", c_char_p),
        ("latency",              PA_USEC_T),
        ("driver",               c_char_p),
        ("flags",                c_int),
        ("proplist",             POINTER(PA_PROPLIST)),
        ("configured_latency",   PA_USEC_T),
        ('base_volume',          c_int),
        ('state',                c_int),
        ('n_volume_steps',       c_int),
        ('card',                 c_uint32),
        ('n_ports',              c_uint32),
        ('ports',                POINTER(POINTER(PA_PORT_INFO))),
        ('active_port',          POINTER(PA_PORT_INFO))
    ]


class PA_CLIENT_INFO(Structure):
    _fields_ = [
        ("index",        c_uint32),
        ("name",         c_char_p),
        ("owner_module", c_uint32),
        ("driver",       c_char_p)
    ]


class PA_CARD_PROFILE_INFO(Structure):
    _fields_ = [
        ('name',        c_char_p),
        ('description', c_char_p),
        ('n_sinks',     c_uint32),
        ('n_sources',   c_uint32),
        ('priority',    c_uint32),
    ]


class PA_CARD_PROFILE_INFO2(Structure):
    _fields_ = PA_CARD_PROFILE_INFO._fields_ + [('available',   c_int)]


class PA_CARD_INFO(Structure):
    _fields_ = [
        ('index',           c_uint32),
        ('name',            c_char_p),
        ('owner_module',    c_uint32),
        ('driver',          c_char_p),
        ('n_profiles',      c_uint32),
        ('profiles',        POINTER(PA_CARD_PROFILE_INFO)),
        ('active_profile',  POINTER(PA_CARD_PROFILE_INFO)),
        ('proplist',        POINTER(PA_PROPLIST)),
        ('n_ports',         c_uint32),
        ('ports',           POINTER(POINTER(c_void_p))),
        ('profiles2',       POINTER(POINTER(PA_CARD_PROFILE_INFO2))),
        ('active_profile2', POINTER(PA_CARD_PROFILE_INFO2))
    ]


class PA_SERVER_INFO(Structure):
    _fields_ = [
        ('user_name',           c_char_p),
        ('host_name',           c_char_p),
        ('server_version',      c_char_p),
        ('server_name',         c_char_p),
        ('sample_spec',         PA_SAMPLE_SPEC),
        ('default_sink_name',   c_char_p),
        ('default_source_name', c_char_p),
    ]


PA_STATE_CB_T              = CFUNCTYPE(c_int, POINTER(PA_CONTEXT), c_void_p)
PA_CLIENT_INFO_CB_T        = CFUNCTYPE(c_void_p, POINTER(PA_CONTEXT), POINTER(PA_CLIENT_INFO), c_int, c_void_p)
PA_SINK_INPUT_INFO_CB_T    = CFUNCTYPE(c_int, POINTER(PA_CONTEXT), POINTER(PA_SINK_INPUT_INFO), c_int, c_void_p)
PA_SINK_INFO_CB_T          = CFUNCTYPE(c_int, POINTER(PA_CONTEXT), POINTER(PA_SINK_INFO), c_int, c_void_p)
PA_SOURCE_OUTPUT_INFO_CB_T = CFUNCTYPE(c_int, POINTER(PA_CONTEXT), POINTER(PA_SOURCE_OUTPUT_INFO), c_int, c_void_p)
PA_SOURCE_INFO_CB_T        = CFUNCTYPE(c_int, POINTER(PA_CONTEXT), POINTER(PA_SOURCE_INFO), c_int, c_void_p)
PA_CONTEXT_SUCCESS_CB_T    = CFUNCTYPE(c_void_p, POINTER(PA_CONTEXT), c_int, c_void_p)
PA_CARD_INFO_CB_T          = CFUNCTYPE(None, POINTER(PA_CONTEXT), POINTER(PA_CARD_INFO), c_int, c_void_p)
PA_SERVER_INFO_CB_T        = CFUNCTYPE(None, POINTER(PA_CONTEXT), POINTER(PA_SERVER_INFO), c_void_p)
PA_CONTEXT_SUBSCRIBE_CB_T  = CFUNCTYPE(c_void_p, POINTER(PA_CONTEXT), c_int, c_int, c_void_p)

pa_threaded_mainloop_new = DLL.pa_threaded_mainloop_new
pa_threaded_mainloop_new.restype = POINTER(PA_THREADED_MAINLOOP)
pa_threaded_mainloop_new.argtypes = []

pa_threaded_mainloop_free = DLL.pa_threaded_mainloop_free
pa_threaded_mainloop_free.restype = c_void_p
pa_threaded_mainloop_free.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_threaded_mainloop_start = DLL.pa_threaded_mainloop_start
pa_threaded_mainloop_start.restype = c_int
pa_threaded_mainloop_start.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_threaded_mainloop_stop = DLL.pa_threaded_mainloop_stop
pa_threaded_mainloop_stop.restype = None
pa_threaded_mainloop_stop.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_threaded_mainloop_lock = DLL.pa_threaded_mainloop_lock
pa_threaded_mainloop_lock.restype = None
pa_threaded_mainloop_lock.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_threaded_mainloop_unlock = DLL.pa_threaded_mainloop_unlock
pa_threaded_mainloop_unlock.restype = None
pa_threaded_mainloop_unlock.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_threaded_mainloop_wait = DLL.pa_threaded_mainloop_wait
pa_threaded_mainloop_wait.restype = None
pa_threaded_mainloop_wait.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_threaded_mainloop_signal = DLL.pa_threaded_mainloop_signal
pa_threaded_mainloop_signal.restype = None
pa_threaded_mainloop_signal.argtypes = [POINTER(PA_THREADED_MAINLOOP), c_int]

pa_threaded_mainloop_get_api = DLL.pa_threaded_mainloop_get_api
pa_threaded_mainloop_get_api.restype = POINTER(PA_MAINLOOP_API)
pa_threaded_mainloop_get_api.argtypes = [POINTER(PA_THREADED_MAINLOOP)]

pa_context_errno = DLL.pa_context_errno
pa_context_errno.restype = c_int
pa_context_errno.argtypes = [POINTER(PA_CONTEXT)]

pa_context_new_with_proplist = DLL.pa_context_new_with_proplist
pa_context_new_with_proplist.restype = POINTER(PA_CONTEXT)
pa_context_new_with_proplist.argtypes = [POINTER(PA_MAINLOOP_API), c_char_p, POINTER(PA_PROPLIST)]

pa_context_unref = DLL.pa_context_unref
pa_context_unref.restype = None
pa_context_unref.argtypes = [POINTER(PA_CONTEXT)]

pa_context_set_state_callback = DLL.pa_context_set_state_callback
pa_context_set_state_callback.restype = None
pa_context_set_state_callback.argtypes = [POINTER(PA_CONTEXT), PA_STATE_CB_T, c_void_p]

pa_context_connect = DLL.pa_context_connect
pa_context_connect.restype = c_int
pa_context_connect.argtypes = [POINTER(PA_CONTEXT), c_char_p, c_int, POINTER(c_int)]

pa_context_get_state = DLL.pa_context_get_state
pa_context_get_state.restype = c_int
pa_context_get_state.argtypes = [POINTER(PA_CONTEXT)]

pa_context_disconnect = DLL.pa_context_disconnect
pa_context_disconnect.restype = c_int
pa_context_disconnect.argtypes = [POINTER(PA_CONTEXT)]

pa_operation_unref = DLL.pa_operation_unref
pa_operation_unref.restype = None
pa_operation_unref.argtypes = [POINTER(PA_OPERATION)]

pa_context_subscribe = DLL.pa_context_subscribe
pa_context_subscribe.restype = POINTER(PA_OPERATION)
pa_context_subscribe.argtypes = [POINTER(PA_CONTEXT), c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_subscribe_callback = DLL.pa_context_set_subscribe_callback
pa_context_set_subscribe_callback.restype = None
pa_context_set_subscribe_callback.args = [POINTER(PA_CONTEXT), PA_CONTEXT_SUBSCRIBE_CB_T, c_void_p]

pa_proplist_new = DLL.pa_proplist_new
pa_proplist_new.restype = POINTER(PA_PROPLIST)

pa_proplist_sets = DLL.pa_proplist_sets
pa_proplist_sets.argtypes = [POINTER(PA_PROPLIST), c_char_p, c_char_p]

pa_proplist_gets = DLL.pa_proplist_gets
pa_proplist_gets.restype = c_char_p
pa_proplist_gets.argtypes = [POINTER(PA_PROPLIST), c_char_p]

pa_proplist_free = DLL.pa_proplist_free
pa_proplist_free.argtypes = [POINTER(PA_PROPLIST)]

pa_context_get_sink_input_info_list = DLL.pa_context_get_sink_input_info_list
pa_context_get_sink_input_info_list.restype = POINTER(PA_OPERATION)
pa_context_get_sink_input_info_list.argtypes = [POINTER(PA_CONTEXT), PA_SINK_INPUT_INFO_CB_T, c_void_p]

pa_context_get_sink_info_list = DLL.pa_context_get_sink_info_list
pa_context_get_sink_info_list.restype = POINTER(PA_OPERATION)
pa_context_get_sink_info_list.argtypes = [POINTER(PA_CONTEXT), PA_SINK_INFO_CB_T, c_void_p]

pa_context_set_sink_mute_by_index = DLL.pa_context_set_sink_mute_by_index
pa_context_set_sink_mute_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_sink_mute_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_suspend_sink_by_index = DLL.pa_context_suspend_sink_by_index
pa_context_suspend_sink_by_index.restype = POINTER(PA_OPERATION)
pa_context_suspend_sink_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_sink_port_by_index = DLL.pa_context_set_sink_port_by_index
pa_context_set_sink_port_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_sink_port_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_char_p, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_sink_input_mute = DLL.pa_context_set_sink_input_mute
pa_context_set_sink_input_mute.restype = POINTER(PA_OPERATION)
pa_context_set_sink_input_mute.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_sink_volume_by_index = DLL.pa_context_set_sink_volume_by_index
pa_context_set_sink_volume_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_sink_volume_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, POINTER(PA_CVOLUME), PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_sink_input_volume = DLL.pa_context_set_sink_input_volume
pa_context_set_sink_input_volume.restype = POINTER(PA_OPERATION)
pa_context_set_sink_input_volume.argtypes = [POINTER(PA_CONTEXT), c_uint32, POINTER(PA_CVOLUME), PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_move_sink_input_by_index = DLL.pa_context_move_sink_input_by_index
pa_context_move_sink_input_by_index.restype = POINTER(PA_OPERATION)
pa_context_move_sink_input_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_uint32, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_default_sink = DLL.pa_context_set_default_sink
pa_context_set_default_sink.restype = POINTER(PA_OPERATION)
pa_context_set_default_sink.argtypes = [POINTER(PA_CONTEXT), c_char_p, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_kill_sink_input = DLL.pa_context_kill_sink_input
pa_context_kill_sink_input.restype = POINTER(PA_OPERATION)
pa_context_kill_sink_input.argtypes = [POINTER(PA_CONTEXT), c_uint32, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_kill_client = DLL.pa_context_kill_client
pa_context_kill_client.restype = POINTER(PA_OPERATION)
pa_context_kill_client.argtypes = [POINTER(PA_CONTEXT), c_uint32, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_get_source_output_info_list = DLL.pa_context_get_source_output_info_list
pa_context_get_source_output_info_list.restype = POINTER(PA_OPERATION)
pa_context_get_source_output_info_list.argtypes = [POINTER(PA_CONTEXT), PA_SOURCE_OUTPUT_INFO_CB_T, c_void_p]

pa_context_move_source_output_by_index = DLL.pa_context_move_source_output_by_index
pa_context_move_source_output_by_index.restype = POINTER(PA_OPERATION)
pa_context_move_source_output_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_uint32, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_source_output_volume = DLL.pa_context_set_source_output_volume
pa_context_set_source_output_volume.restype = POINTER(PA_OPERATION)
pa_context_set_source_output_volume.argtypes = [POINTER(PA_CONTEXT), c_uint32, POINTER(PA_CVOLUME), PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_source_output_mute = DLL.pa_context_set_source_output_mute
pa_context_set_source_output_mute.restype = POINTER(PA_OPERATION)
pa_context_set_source_output_mute.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_get_source_info_list = DLL.pa_context_get_source_info_list
pa_context_get_source_info_list.restype = POINTER(PA_OPERATION)
pa_context_get_source_info_list.argtypes = [POINTER(PA_CONTEXT), PA_SOURCE_INFO_CB_T, c_void_p]

pa_context_set_source_volume_by_index = DLL.pa_context_set_source_volume_by_index
pa_context_set_source_volume_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_source_volume_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, POINTER(PA_CVOLUME), PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_source_mute_by_index = DLL.pa_context_set_source_mute_by_index
pa_context_set_source_mute_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_source_mute_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_suspend_source_by_index = DLL.pa_context_suspend_source_by_index
pa_context_suspend_source_by_index.restype = POINTER(PA_OPERATION)
pa_context_suspend_source_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_int, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_source_port_by_index = DLL.pa_context_set_source_port_by_index
pa_context_set_source_port_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_source_port_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_char_p, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_set_default_source = DLL.pa_context_set_default_source
pa_context_set_default_source.restype = POINTER(PA_OPERATION)
pa_context_set_default_source.argtypes = [POINTER(PA_CONTEXT), c_char_p, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_kill_source_output = DLL.pa_context_kill_source_output
pa_context_kill_source_output.restype = POINTER(PA_OPERATION)
pa_context_kill_source_output.argtypes = [POINTER(PA_CONTEXT), c_uint32, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_get_client_info_list = DLL.pa_context_get_client_info_list
pa_context_get_client_info_list.restype = POINTER(PA_OPERATION)
pa_context_get_client_info_list.argtypes = [POINTER(PA_CONTEXT), PA_CLIENT_INFO_CB_T, c_void_p]

pa_context_get_card_info_list = DLL.pa_context_get_card_info_list
pa_context_get_card_info_list.restype = POINTER(PA_OPERATION)
pa_context_get_card_info_list.argtypes = [POINTER(PA_CONTEXT), PA_CARD_INFO_CB_T, c_void_p]

pa_context_set_card_profile_by_index = DLL.pa_context_set_card_profile_by_index
pa_context_set_card_profile_by_index.restype = POINTER(PA_OPERATION)
pa_context_set_card_profile_by_index.argtypes = [POINTER(PA_CONTEXT), c_uint32, c_char_p, PA_CONTEXT_SUCCESS_CB_T, c_void_p]

pa_context_get_server_info = DLL.pa_context_get_server_info
pa_context_get_server_info.restype = POINTER(PA_OPERATION)
pa_context_get_server_info.argtypes = [POINTER(PA_CONTEXT), PA_SERVER_INFO_CB_T, c_void_p]

pa_get_library_version = DLL.pa_get_library_version
pa_get_library_version.restype = c_char_p
PA_MAJOR = int(pa_get_library_version().decode().split('.')[0])

# ^ bindings
#########################################################################################
# v lib


def main():
  print("hello")


if __name__ == '__main__':
    main()