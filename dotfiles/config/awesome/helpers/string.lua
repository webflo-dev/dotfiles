local helpers = {}

function helpers.remove_linebreaks(str)
  return string.gsub(str, "\n", "")
end

return helpers
