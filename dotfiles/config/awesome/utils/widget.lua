local M = {}

function M.factory(new_func)
	local instanciable_widget = { mt = {} }

	function instanciable_widget.mt.__call(_, ...)
		return new_func(...)
	end

	return setmetatable(instanciable_widget, instanciable_widget.mt)
end

function M.find_by_id(widgets, id)
	for _, value in ipairs(widgets) do
		if value.id == id then
			return value
		end
	end
	return nil
end

function M.index_of(widgets, id)
	for index, value in ipairs(widgets) do
		if value.id == id then
			return index
		end
	end
	return nil
end

return M
