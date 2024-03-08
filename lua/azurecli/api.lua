local Api = {}

local function execute_command(command)
	local handle = assert(io.popen(command, "r"))
	local result = assert(handle:read("*a"))
	handle:close()
	return vim.json.decode(result)
end

function Api.get_all_items()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.WorkItemType] IN ('Task', 'User Story', 'Bug', 'Defect')\""
	result = execute_command(command)
	return result
end

function Api.get_tasks()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.WorkItemType] = 'Task'\""
	result = execute_command(command)
	return result
end

function Api.get_user_stories()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.WorkItemType] = 'User Story'\""
	result = execute_command(command)
	return result
end

function Api.get_bugs()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.WorkItemType] = 'Bug'\""
	result = execute_command(command)
	return result
end

function Api.get_defects()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.WorkItemType] = 'Defect'\""
	result = execute_command(command)
	return result
end

function Api.get_issues()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.WorkItemType] = 'Issue'\""
	result = execute_command(command)
	return result
end

return Api
