local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Line = require("nui.line")
local Text = require("nui.text")

local Window = {}

local append_multiline_to_buffer = function(bufnr, str)
	vim.api.nvim_buf_set_option(bufnr, "modifiable", true)

	local lines = vim.split(str, "\n")

	local current_line = vim.api.nvim_buf_line_count(bufnr)

	for _, line_str in ipairs(lines) do
		local line = Line()
		local text = Text(line_str, "Normal")
		line:append(text)
		line:render(bufnr, current_line, current_line)
		current_line = current_line + 1
	end

	vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
	vim.api.nvim_buf_set_option(bufnr, "readonly", true)
end

function Window.open_window(work_item)
	local popups = {
		popup_id = Popup({
			border = {
				style = "single",
				text = {
					top = "ID",
				},
			},
			enter = true,
		}),

		popup_title = Popup({
			border = {
				style = "single",
				text = {
					top = "Title",
				},
			},
		}),

		popup_state = Popup({
			border = {
				style = "single",
				text = {
					top = "State",
				},
			},
		}),

		popup_desc = Popup({
			border = {
				style = "single",
				text = {
					top = "Description",
				},
			},
		}),
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
			Layout.Box(popups["popup_desc"], { grow = 1 }),
		}, { dir = "col", size = "60%" })
	)

	layout:mount()

	for _, popup in pairs(popups) do
		-- Handle Buff Leave Event
		popup:on("BufLeave", function()
			vim.schedule(function()
				local curr_bufnr = vim.api.nvim_get_current_buf()
				for _, p in pairs(popups) do
					if p.bufnr == curr_bufnr then
						return
					end
				end
				layout:unmount()
			end)
		end)

		-- Binding of esc key
		popup:map("n", "<Esc>", function()
			layout:unmount()
		end, { noremap = true })
	end

	local id = tostring(work_item["fields"]["System.Id"])
	local title = work_item["fields"]["System.Title"]
	local state = work_item["fields"]["System.State"]
	local desc = work_item["fields"]["System.Description"] or "-- empty --"

	append_multiline_to_buffer(popups["popup_id"].bufnr, id)
	append_multiline_to_buffer(popups["popup_title"].bufnr, title)
	append_multiline_to_buffer(popups["popup_state"].bufnr, state)
	append_multiline_to_buffer(popups["popup_desc"].bufnr, desc)
end

return Window
