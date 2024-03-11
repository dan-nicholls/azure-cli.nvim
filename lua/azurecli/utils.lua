local Line = require("nui.line")
local Text = require("nui.text")

local Utils = {}

Utils.html_to_markdown = function(html)
	-- Convert line breaks and divs
	html = html:gsub("<ul>", "\n")
	html = html:gsub("</ul>", "")
	html = html:gsub("<li>", "- ")
	html = html:gsub("</li>", "\n")
	html = html:gsub("<br%s*/>", "\n\n")
	html = html:gsub("<div>", "")
	html = html:gsub("</div>", "\n")

	-- Convert links
	html = html:gsub('<a href="([^"]+)">([^<]+)</a>', "[%2](%1)")

	-- Convert bold text
	html = html:gsub("<b>(.-)</b>", "**%1**")
	html = html:gsub("<strong>(.-)</strong>", "**%1**")

	-- Convert italic text
	html = html:gsub("<i>(.-)</i>", "*%1*")
	html = html:gsub("<em>(.-)</em>", "*%1*")

	-- Remove any other HTML tags (simplistic, consider more robust parsing for complex HTML)
	html = html:gsub("<%/?[%w%s=\"'-]+>", "")

	return html
end

Utils.append_multiline_to_buffer = function(bufnr, str)
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

Utils.append_markdown_to_buffer = function(bufnr, str)
	markdown_content = Utils.html_to_markdown(str)

	vim.api.nvim_buf_set_option(bufnr, "modifiable", true)

	local lines = vim.split(markdown_content, "\n")

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
	vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
end

return Utils
