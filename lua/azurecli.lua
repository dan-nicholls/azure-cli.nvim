local api = require("azurecli.api")
local picker = require("azurecli.picker")

local M = {}

M.setup = function(options)
	print("Azure CLI Plugin Setup")
end

M.get_all_items = function()
	local results = api.get_all_items()
	picker.use_picker(results)
end

M.get_tasks = function()
	local results = api.get_tasks()
	picker.use_picker(results)
end

M.get_user_stories = function()
	local results = api.get_user_stories()
	picker.use_picker(results)
end

M.get_bugs = function()
	local results = api.get_bugs()
	picker.use_picker(results)
end

M.get_defects = function()
	local results = api.get_defects()
	picker.use_picker(results)
end

M.get_issues = function()
	local results = api.get_issues()
	picker.use_picker(results)
end

return M
