local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Utils = require("azurecli.utils")

local Window = {}

local function createPopup(label, enter)
	return Popup({
		border = {
			style = "single",
			text = {
				top = label,
			},
		},

		enter = enter or false,
	})
end

local function setupEventHandlers(popup, layout)
	popup:map("n", "<Esc>", function()
		layout:unmount()
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
		popup_desc = createPopup("Description"),
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
			Layout.Box(popups["popup_desc"], { grow = 1, enter = true, focusable = true }),
			-- Layout.Box(popups["popup_src"], { grow = 1 }),
		}, { dir = "col", size = "60%" })
	)

	layout:mount()

	for _, popup in pairs(popups) do
		setupEventHandlers(popup, layout)
	end

	local id = tostring(work_item["fields"]["System.Id"])
	local title = work_item["fields"]["System.Title"]
	local state = work_item["fields"]["System.State"]
	local desc = work_item["fields"]["System.Description"] or "-- empty --"

	Utils.append_multiline_to_buffer(popups["popup_id"].bufnr, id)
	Utils.append_multiline_to_buffer(popups["popup_title"].bufnr, title)
	Utils.append_multiline_to_buffer(popups["popup_state"].bufnr, state)
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
