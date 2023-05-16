from utils.colors import colors
from core.keys import keys
from core.groups import groups
from core.layouts import layouts, floating_layout
from core.screens import screens
from core.mouse import mouse
from core.hooks import autostart


dgroups_key_binder = None
dgroups_app_rules = [] # type: list

auto_fullscreen = False
bring_front_click = True
cursor_warp = False
dgroups_key_binder = None
focus_on_window_activation = "urgent" # "smart"
follow_mouse_focus = False
reconfigure_screens = True
auto_minimize = True
wmname = "qtile"

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

