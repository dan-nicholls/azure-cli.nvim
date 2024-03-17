local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Utils = require("azurecli.utils")
local Config = require("azurecli.config")

local Window = {}

local function createPopup(label, enter, readonly, modifiable)
	return Popup({
		border = {
			style = "single",
			text = {
				top = label,
			},
		},
		enter = enter or false,
		buf_options = {
			readonly = readonly or false,
			modifiable = modifiable or false,
		},
	})
end

local function setupEventHandlers(popup, layout)
	popup:map("n", "<Esc>", function()
		layout:unmount()
	end, { noremap = true })
	popup:map("n", "<Tab>", function()
		return true
	end, { noremap = true })

	-- Handle Buff Leave Event
	-- popup:on("BufLeave", function()
	-- 	vim.schedule(function()
	-- 		local curr_bufnr = vim.api.nvim_get_current_buf()
	-- 		for _, p in pairs(popups) do
	-- 			if p.bufnr == curr_bufnr then
	-- 				return
	-- 			end
	-- 		end
	-- 		layout:unmount()
	-- 	end)
	-- end)
end

function Window.open_window(work_item)
	local popups = {
		popup_id = createPopup("ID"),
		popup_title = createPopup("Title"),
		popup_state = createPopup("State"),
		popup_type = createPopup("Type"),
		popup_assigned_to = createPopup("Assigned To"),
		popup_desc = createPopup("Description", true, true, true),
		popup_src = createPopup("Source"),
	}

	local layout = Layout(
		{
			relative = "editor",
			position = "50%",
			size = {
				width = "80%",
				height = "80%",
			},
		},
		Layout.Box({
			Layout.Box({
				Layout.Box(popups["popup_id"], { size = "5%" }),
				Layout.Box(popups["popup_title"], { grow = 1 }),
				Layout.Box(popups["popup_state"], { size = "10%" }),
			}, { dir = "row", size = {
				height = 3,
			} }),
			Layout.Box({
				Layout.Box(popups["popup_type"], { size = 20 }),
				Layout.Box(popups["popup_assigned_to"], { grow = 5 }),
			}, { size = { height = 3 } }),
			Layout.Box(popups["popup_desc"], { grow = 1 }),
			-- Layout.Box(popups["popup_src"], { grow = 1 }),
		}, { dir = "col", size = "60%", enter = true })
	)

	layout:mount()

	for _, popup in pairs(popups) do
		setupEventHandlers(popup, layout)
	end

	local id = tostring(work_item["fields"]["System.Id"])
	local title = work_item["fields"]["System.Title"]
	local state = work_item["fields"]["System.State"]
	local icon = Config.types.icons[work_item["fields"]["System.WorkItemType"]] or Config.types.icons["Default"]
	local type = icon .. "\t" .. work_item["fields"]["System.WorkItemType"]
	local assigned_to = (
		work_item["fields"]["System.AssignedTo"] and work_item["fields"]["System.AssignedTo"]["displayName"]
	) or "Not Assigned"
	local desc = work_item["fields"]["System.Description"] or "-- empty --"

	Utils.append_multiline_to_buffer(popups["popup_id"].bufnr, id)
	Utils.append_multiline_to_buffer(popups["popup_title"].bufnr, title)
	Utils.append_multiline_to_buffer(popups["popup_state"].bufnr, state)
	Utils.append_multiline_to_buffer(popups["popup_type"].bufnr, type)
	Utils.append_multiline_to_buffer(popups["popup_assigned_to"].bufnr, assigned_to)
	Utils.append_markdown_to_buffer(popups["popup_desc"].bufnr, desc)
	Utils.append_multiline_to_buffer(popups["popup_src"].bufnr, vim.inspect(work_item))

	local layout_state = "desc"

	local swap_popups = function()
		if layout_state == "src" then
			layout:update(Layout.Box({
				Layout.Box({
					Layout.Box(popups["popup_id"], { size = "5%" }),
					Layout.Box(popups["popup_title"], { grow = 1 }),
					Layout.Box(popups["popup_state"], { size = "10%" }),
				}, { dir = "row", size = {
					height = 3,
				} }),
				Layout.Box({
					Layout.Box(popups["popup_type"], { size = 20 }),
					Layout.Box(popups["popup_assigned_to"], { grow = 5 }),
				}, { size = { height = 3 } }),
				Layout.Box(popups["popup_desc"], { grow = 1, enter = true, focusable = true }),
			}, { dir = "col", size = "60%" }))
			layout_state = "desc"
		else
			layout:update(Layout.Box({
				Layout.Box({
					Layout.Box(popups["popup_id"], { size = "5%" }),
					Layout.Box(popups["popup_title"], { grow = 1 }),
					Layout.Box(popups["popup_state"], { size = "10%" }),
				}, { dir = "row", size = {
					height = 3,
				} }),
				Layout.Box({
					Layout.Box(popups["popup_type"], { size = 20 }),
					Layout.Box(popups["popup_assigned_to"], { grow = 5 }),
				}, { size = { height = 3 } }),
				Layout.Box(popups["popup_src"], { grow = 1, enter = true, focusable = true }),
			}, { dir = "col", size = "60%" }))

			layout_state = "src"
		end
	end

	-- Binding of 's' key to swap popup_desc with popup_src
	popups["popup_desc"]:map("n", "s", swap_popups, { noremap = true })
	popups["popup_src"]:map("n", "s", swap_popups, { noremap = true })
end

return Window
