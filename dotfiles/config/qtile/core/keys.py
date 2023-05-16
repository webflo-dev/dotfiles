from libqtile.config import Key, KeyChord
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from utils.settings import terminal
from utils.commands import volume_down, volume_up, volume_mute, brightness_down, brightness_up, menu_launcher, lock, menu_screenshot

MOD = "mod4"
ALT = "mod1"
CTL = "control"
SHIFT = "shift"


keys = [

    Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([MOD], "k", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "j", lazy.layout.up(), desc="Move focus up"),

    Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    Key([MOD], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([MOD, SHIFT], "space",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc="Flip the layout"),


    Key([MOD, CTL], "j", lazy.layout.flip_up(), desc="Flip window up"),
    Key([MOD, CTL], "k", lazy.layout.flip_down(), desc="Flip window down"),
    Key([MOD, CTL], "l", lazy.layout.flip_right(), desc="Flip window right"),
    Key([MOD, CTL], "h", lazy.layout.flip_left(), desc="Flip window left"),

    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([MOD, SHIFT], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_up(), desc="Move window up"),


    Key([MOD, SHIFT], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    Key([MOD,CTL], "space", lazy.window.toggle_floating(), desc="Toggle between tile and floating mode"),

    # lazy.layout.grow_left().when(layout="monadwide" or "monadtall" or "monadthreecol"),
    KeyChord([MOD], "g", [
        Key([], "h",
            lazy.layout.grow_left(),
            lazy.layout.shrink(),
            lazy.layout.decrease_ratio(),
            lazy.layout.add(),
            desc="Grow window to the left"),
        Key([], "l",
            lazy.layout.grow_right(),
            lazy.layout.grow(),
            lazy.layout.increase_ratio(),
            lazy.layout.delete(),
            desc="Grow window to the right"),
        Key([], "k",
            lazy.layout.grow_down(),
            lazy.layout.shrink(),
            lazy.layout.increase_nmaster(),
            desc="Grow window down"),
        Key([], "j",
            lazy.layout.grow_up(),
            lazy.layout.grow(),
            lazy.layout.decrease_nmaster(),
            desc="Grow window up"),
        Key([], "m",
            lazy.layout.maximize(),
            desc="Maximize window"),
        Key([], "n",
            lazy.layout.normalize(),
            desc="Reset all window sizes"),
    ], mode="Resize"),

    Key([MOD], "p", lazy.spawn(menu_screenshot), desc="launch screenshot menu"),


    KeyChord([MOD], "a", [
        Key([], "m", lazy.spawn(volume_mute), desc="Mute Audio"),
        Key([], "Up", lazy.spawn(volume_up), desc="Volume up"),
        Key([], "Down", lazy.spawn(volume_down), desc="Volume down"),
    ], mode="Audio:  (m)    (up)    dpuls(down)"),



    Key([MOD, CTL], "r", lazy.restart(), desc="Restart Qtile"),
    Key([MOD, CTL], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    Key([MOD], "d", lazy.spawn(menu_launcher), desc="Run launcher"),
    Key([MOD], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([MOD], "Return", lazy.spawn(terminal),desc="Launch terminal"),
    Key([], "F9", lazy.group["dropdown"].dropdown_toggle("term"), desc="Toggle the terminal scratchpad"),

    # Key([CTL], "F1", lazy.function(Helpers.go_to_urgent), desc="Switch to urgent group"),
    Key([MOD], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    
    Key([MOD], "q", lazy.window.kill(), desc="Kill focused window"),



    Key([MOD], "t", lazy.group["scratchpad"].dropdown_toggle("alacritty")),
    Key([MOD], "u", lazy.group["scratchpad"].dropdown_toggle("pulsemixer")),
    Key([MOD], "Escape", lazy.spawn(lock)),


    Key([], "XF86AudioRaiseVolume", lazy.spawn(volume_down), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn(volume_up), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn(volume_mute), desc="Mute Audio"),
    Key([], "XF86MonBrightnessDown", lazy.spawn(brightness_down), desc="Decrease Screen Brightness"),
    Key([], "XF86MonBrightnessUp", lazy.spawn(brightness_up), desc="Increase Screen Brightness"),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Toggle Play-Pasue Music"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Play Previous Music Track"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Play Next Music Track"),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop"), desc="Stop the Music"),
    # Key([], "Print", lazy.spawn("flameshot"), desc="Take screenshot"),
]
