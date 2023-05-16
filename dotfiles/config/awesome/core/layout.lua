local awful = require("awful")
local bling = require("modules.bling")


--- Set the layouts
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- bling.layout.centered,
    bling.layout.mstab,
    -- bling.layout.equalarea,
    -- bling.layout.deck
    awful.layout.suit.fair,
  })
end)



-- Restore client after tiling layout
tag.connect_signal('property::layout', function(t)
  for k, c in ipairs(t:clients()) do
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
      local cgeo = awful.client.property.get(c, 'floating_geometry')
      if cgeo then
        c:geometry(awful.client.property.get(c, 'floating_geometry'))
      end
    end
  end
end)

client.connect_signal('manage', function(c)
  if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
    awful.client.property.set(c, 'floating_geometry', c:geometry())
  end
end)

client.connect_signal('property::geometry', function(c)
  if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
    awful.client.property.set(c, 'floating_geometry', c:geometry())
  end
end)


-- Disable titlebar when tiled
-- local disable_titlebar = function(t)
--   for k, c in ipairs(t:clients()) do
--     if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
--       awful.titlebar.hide(c)
--     else
--       awful.titlebar.show(c)
--     end
--   end
-- end

-- tag.connect_signal('property::layout', function(t)
--   disable_titlebar(t)
-- end)

-- client.connect_signal("request::manage", function(c)
--   if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
--     awful.titlebar.hide(c)
--   else
--     awful.titlebar.show(c)
--   end
-- end)
