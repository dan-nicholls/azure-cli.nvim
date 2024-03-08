local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local action_state = require("telescope.actions.state")

local Config = require("azurecli.config")
local Window = require("azurecli.window")

local M = {}

local function entry_maker(entry)
	local entry_type = entry["fields"]["System.WorkItemType"]
	local icon = Config.types.icons[entry_type] or Config.types.icons["Default"]
	local label = string.format(
		"%s: %s [%s]",
		entry["fields"]["System.Id"],
		entry["fields"]["System.Title"],
		entry["fields"]["System.State"]
	)

	local display = icon .. "\t " .. label
	local value = entry

	return {
		value = value,
		display = display,
		ordinal = display,
	}
end

function M.use_picker(data)
	local opts = {}

	pickers
		.new(opts, {
			results_title = "Result Title",
			prompt_title = "Prompt Title",
			sorter = sorters.get_generic_fuzzy_sorter(),
			finder = finders.new_table({
				results = data,
				entry_maker = entry_maker,
			}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						-- Do stuff here
						Window.open_window(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
