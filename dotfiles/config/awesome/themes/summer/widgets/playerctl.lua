local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local bling = require("modules.bling")

local dpi = beautiful.xresources.apply_dpi

local box = require("themes.summer.widgets.base.box")
local helperUI = require("helpers.ui")



-- awful.spawn.with_line_callback("playerctl " .. playername ..
--   " --follow metadata --format '{{ playerName }}|{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}'"
--   , {
--   stdout = function(line)
--     local values = gears.string.split(line, '|')

--     local playerName = values[1]
--     local artist = values[2]
--     local title = values[3]

--     artist_widget:set_markup_silently(artist)
--     title_widget:set_markup_silently(title)
--   end,
--   stderr = function(line)
--     artist_widget:set_markup_silently(helperUI.colorize_text("ERROR", beautiful.red))
--     title_widget:set_markup_silently(line)
--   end,
-- })

local function secondsToClock(seconds)
  local seconds = tonumber(seconds)
  if seconds <= 0 then
    return "00:00:00";
  else
    local hours = string.format("%02.f", math.floor(seconds / 3600));
    local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
    local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
    if hours == "00" then
      return mins .. ":" .. secs
    else
      return hours .. ":" .. mins .. ":" .. secs
    end
  end
end

local playerctl_widget = {}


local function worker(user_args)

  local args = user_args or {}
  local player = '--all-players'
  if args.player then
    player = "-p " .. args.player
  end


  local widget_grid = wibox.widget {
    spacing = 5,
    expand = true,
    homogeneous = false,
    layout = wibox.layout.grid,
  }

  local artist_widget = wibox.widget {
    widget = wibox.widget.textbox,
    id = 'artist',
  }

  local title_widget = wibox.widget {
    widget = wibox.widget.textbox,
    id = 'title',
  }

  local cover_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    id = 'cover'
  }

  local time_widget = wibox.widget {
    {
      text   = ' ',
      widget = wibox.widget.textbox,
      font   = "DejaVu Sans Mono",
      valign = "center",
      halign = "center",
      id     = 'position',
    },
    {
      text   = ' ',
      widget = wibox.widget.textbox,
      font   = "DejaVu Sans Mono",
      valign = "center",
      halign = "center",
      id     = 'duration'
    },
    layout          = wibox.layout.grid,
    forced_num_cols = 1,
    forced_num_rows = 2,
    spacing         = 5,
    homogeneous     = true,
    expand          = true,
    set_time        = function(self, position, durationRemaining)
      self:get_children_by_id('position')[1]:set_text(position)
      self:get_children_by_id('duration')[1]:set_markup("<span size='small'>-" .. durationRemaining .. "</span>")
    end
  }

  local progressbar_widget = wibox.widget {
    {
      {
        max_value        = 1,
        value            = 0,
        background_color = "#00000000",
        color            = beautiful.green,
        widget           = wibox.widget.progressbar,
        id               = "progressbar"
      },
      forced_width = dpi(20),
      direction    = 'east',
      layout       = wibox.container.rotate,
    },
    {
      time_widget,
      widget = wibox.container.margin,
      margins = dpi(5),
    },
    layout = wibox.layout.stack,
    set_value = function(self, value)
      self:get_children_by_id("progressbar")[1]:set_value(value)
    end
  }

  playerctl_widget = wibox.widget {
    {
      progressbar_widget,
      widget = wibox.container.background,
      shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 8) end,
      -- bg = beautiful.bg_normal,
      bg = beautiful.bg_normal,
      fg = beautiful.fg_normal,
    },
    {
      {
        widget_grid,
        widget = wibox.container.margin,
        right = dpi(10),
      },
      widget = wibox.container.background,
      bg = beautiful.bg_normal,
      fg = "#FFFFFF",
      shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 8) end,
    },
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.margin,
  }


  widget_grid:add_widget_at(cover_widget, 1, 1, 2, 1)
  widget_grid:add_widget_at(title_widget, 1, 2, 1, 1)
  widget_grid:add_widget_at(artist_widget, 2, 2, 1, 1)


  playerctl_widget:set_visible(false)

  local playerctl = bling.signal.playerctl.lib({
    update_on_activity = true,
  })
  playerctl:connect_signal("metadata",
    function(_, title, artist, album_path, album, new, player_name)
      local _new = "not-new"
      if new == true then
        _new = "new"
      end
      -- gears.debug.print_warning("title: " ..
      --   title .. " >> " .. artist .. " >> " .. album_path .. " >> " .. album .. " >> " .. _new .. " >> " .. player_name)

      playerctl_widget:set_visible(true)

      if album_path and album_path ~= '' then
        cover_widget:set_image(gears.surface.load_uncached(album_path))
        cover_widget:set_visible(true)
      else
        cover_widget:set_visible(false)
      end

      artist_widget:set_markup("<span size='small'>" .. artist .. "</span>")
      title_widget:set_markup(title)

    end)

  -- playerctl:connect_signal("playback_status",
  --   function(_, playing, player_name)

  --     local _playing = "not-playing"
  --     if playing == true then
  --       _playing = "playing"
  --     end
  --     gears.debug.print_warning(_playing .. " >> " .. player_name)

  --     if playing then
  --       playerctl_widget:set_opacity(1)
  --     else
  --       playerctl_widget:set_opacity(0.5)
  --     end
  --   end)

  playerctl:connect_signal("position", function(_, interval_sec, length_sec, player_name)
    progressbar_widget:set_value(1 - interval_sec / length_sec)
    time_widget:set_time(secondsToClock(interval_sec), secondsToClock(length_sec - interval_sec))
  end)


  playerctl:connect_signal("no_players", function()
    playerctl_widget:set_visible(false)
  end)

  return playerctl_widget

end

return setmetatable(playerctl_widget, { __call = function(_, ...)
  return worker(...)
end })
