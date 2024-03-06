local Api = {}

local function execute_command(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

function Api.get_all_items()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.WorkItemType] IN ('Task', 'User Story', 'Bug', 'Defect', 'Defect')\" -o table"
	result = execute_command(command)
	print(result)
end

function Api.get_tasks()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.WorkItemType] = 'Task'\" -o table"
	result = execute_command(command)
	print(result)
end

function Api.get_user_stories()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.WorkItemType] = 'User Story'\" -o table"
	result = execute_command(command)
	print(result)
end

function Api.get_bugs()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.WorkItemType] = 'Bug'\" -o table"
	result = execute_command(command)
	print(result)
end

function Api.get_defects()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.WorkItemType] = 'Defect'\" -o table"
	result = execute_command(command)
	print(result)
end

function Api.get_issues()
	local command =
		"az boards query --wiql \"SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.WorkItemType] = 'Issue'\" -o table"
	result = execute_command(command)
	print(result)
end

return Api
