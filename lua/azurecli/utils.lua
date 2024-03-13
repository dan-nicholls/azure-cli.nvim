local Line = require("nui.line")
local Text = require("nui.text")

local Utils = {}

Utils.ts_tree_to_markdown = function(node, html)
	local markdown = {}

	local function traverse(node, markdownPrefix)
		local type = node:type()
		local start_row, start_col, end_row, end_col = node:range()
		-- Extract the text directly from the 'html' string using node ranges.
		local nodeText = html:sub(start_col + 1, end_col)

		-- Apply Markdown formatting based on the node type.
		if type == "element" then
			local tagName = ""
			for child in node:iter_children() do
				if child:type() == "tag_name" then
					tagName = html:sub(child:range()) -- Assuming tag_name nodes cover the tag names fully.
					break
				end
			end

			if tagName == "b" then
				markdownPrefix = markdownPrefix .. "**"
			elseif tagName == "i" then
				markdownPrefix = markdownPrefix .. "*"
			end
		elseif type == "text" and nodeText ~= "" then
			-- Apply markdown formatting.
			table.insert(markdown, markdownPrefix .. nodeText .. string.reverse(markdownPrefix))
			markdownPrefix = ""
		end

		-- Process child nodes
		for child in node:iter_children() do
			traverse(child, markdownPrefix)
		end
	end

	traverse(node, "")
	return table.concat(markdown, " ")
end

Utils.convert_html_to_markdown_via_ts = function(html)
	local parser = vim.treesitter.get_string_parser(html, "html")

	if not parser then
		print("Failed to get parser")
		return ""
	end

	local tree = parser:parse()[1]
	if not tree then
		print("Failed to parse HTML")
		return ""
	end

	return Utils.ts_tree_to_markdown(tree:root(), html)
end

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

	-- Remove any other HTML tags
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
	local markdown_content = Utils.html_to_markdown(str)

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
