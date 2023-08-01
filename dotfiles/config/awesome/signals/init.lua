require(... .. ".volume")
require(... .. ".mic")
require(... .. ".power")
require(... .. ".cpu")
require(... .. ".memory")
require(... .. ".bluetooth")
require(... .. ".network")
require(... .. ".nvidia")

local M = {}

M.playerctl = require(... .. ".playerctl")
M.screenrecord_signals = require(... .. ".screenrecord")
M.screenshot_signals = require(... .. ".screenshot")
M.overmind = require(... .. ".overmind")

return M
