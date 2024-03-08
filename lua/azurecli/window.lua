local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local Window = {}

function Window.open_window(work_item)
	local popup = Popup({
		enter = true,
		focusable = true,
		relative = "editor",
		border = {
			style = "rounded",
		},
		position = "50%",
		size = {
			width = "80%",
			height = "60%",
		},
	})

	local tableStr = vim.inspect(work_item)

	popup:mount()

	popup:on(event.BufLeave, function()
		popup:unmount()
	end)

	local bufnr = popup.bufnr

	vim.api.nvim_buf_set_option(bufnr, "modifiable", true)

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(tableStr, "\n"))

	vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
	vim.api.nvim_buf_set_option(bufnr, "readonly", true)
end

return Window
