import subprocess
from libqtile import hook, qtile
from libqtile.log_utils import logger

from utils.commands import local_bin

@hook.subscribe.startup
def autostart():
    subprocess.run([
        local_bin + "autostart"
    ])


sticky_list = []


@hook.subscribe.client_new
def sticky_window(window):
    global sticky_list
    type = window.window.get_wm_type()
    state = window.window.get_net_wm_state()
    role = window.window.get_wm_window_role()
    # logger.warning(f"type => {type}, state => {state}, role => {role}")
    if state and '_NET_WM_STATE_STICKY' and '_NET_WM_STATE_ABOVE' in state:
        window.floating = True
        sticky_list.append(window)

@hook.subscribe.client_killed
def unsticky_window(window):
    global sticky_list
    if window in sticky_list:
        sticky_list.remove(window)

@hook.subscribe.setgroup
def move_sticky_window():
    global sticky_list
    for window in sticky_list:
        window.togroup(qtile.current_group.name)

@hook.subscribe.client_focus
def stay_above(window):
    global sticky_list
    for window in sticky_list:
        window.cmd_bring_to_front()



# floating_window_index = 0
# def float_cycle(qtile, forward: bool):
#     global floating_window_index
#     floating_windows = []
#     for window in qtile.current_group.windows:
#         if window.floating:
#             floating_windows.append(window)
#     if not floating_windows:
#         return
#     floating_window_index = min(floating_window_index, len(floating_windows) -1)
#     if forward:
#         floating_window_index += 1
#     else:
#         floating_window_index += 1
#     if floating_window_index >= len(floating_windows):
#         floating_window_index = 0
#     if floating_window_index < 0:
#         floating_window_index = len(floating_windows) - 1
#     win = floating_windows[floating_window_index]
#     win.cmd_bring_to_front()
#     win.cmd_focus()
