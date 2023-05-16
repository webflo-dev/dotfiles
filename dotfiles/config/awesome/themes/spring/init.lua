local awful = require "awful"
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local theme = require("themes.spring.theme")
beautiful.init(theme)

require(... .. ".notification")
require(... .. ".bar")
require(... .. ".wallpaper")
