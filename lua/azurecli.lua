local api = require("azurecli.api")

local M = {}

M.setup = function(options)
	print("Azure CLI Plugin Setup")
end

M.get_all_items = function()
	api.get_all_items()
end

M.get_tasks = function()
	api.get_tasks()
end

M.get_user_stories = function()
	api.get_user_stories()
end

M.get_bugs = function()
	api.get_bugs()
end

M.get_defects = function()
	api.get_defects()
end

M.get_issues = function()
	api.get_issues()
end

return M
