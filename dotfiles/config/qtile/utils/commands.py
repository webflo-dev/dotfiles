from os.path import expanduser

local_bin = expanduser("~/.local/bin/")

volume_current = local_bin + "volume --value"
volume_up = local_bin + "volume --up"
volume_down = local_bin + "volume --down"
volume_mute = local_bin + "volume --toggle-mute"
brightness_up = local_bin + "brightness --up"
brightness_down = local_bin + "brightness --down"
menu_launcher = local_bin + "menu --launcher"
menu_screenshot = local_bin + "menu --screenshot"
lock = local_bin + "lock"
