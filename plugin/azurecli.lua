vim.api.nvim_create_user_command("AzureCli", function()
	require("azurecli").get_all_items()
end, {})

vim.api.nvim_create_user_command("AzureCliTasks", function()
	require("azurecli").get_tasks()
end, {})

vim.api.nvim_create_user_command("AzureCliUserStories", function()
	require("azurecli").get_user_stories()
end, {})

vim.api.nvim_create_user_command("AzureCliBugs", function()
	require("azurecli").get_bugs()
end, {})

vim.api.nvim_create_user_command("AzureCliDefects", function()
	require("azurecli").get_defects()
end, {})

vim.api.nvim_create_user_command("AzureCliIssues", function()
	require("azurecli").get_issues()
end, {})
