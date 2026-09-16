local wezterm = require("wezterm")
local projects = require("projects.projects-samples")
local M = {}

-- Helper to convert projects into selection choices
local function get_projects_choices()
	local choices = {}
	for _, project in ipairs(projects) do
		table.insert(choices, { label = project.id .. " - " .. project.name, id = project.id })
	end
	return choices
end

-- Helper to find project details by its unique id
local function get_project_by_id(id)
	for _, project in ipairs(projects) do
		if project.id == id then
			return project
		end
	end
	return nil
end

-- Helper function to open a tab in the correct working directory
local function perform_open_tab(window, pane, name, opts)
	window:perform_action(
		wezterm.action.SpawnCommandInNewTab({
			cwd = opts.cwd,
		}),
		pane
	)
end

-- Main function to invoke the Interactive Input Selector
function M.select_project()
	local choices = get_projects_choices()

	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			wezterm.action.InputSelector({
				action = wezterm.action_callback(function(window2, pane2, id)
					if not id then
						return
					end -- User pressed Escape / cancelled

					local project = get_project_by_id(id)
					if project ~= nil then
						perform_open_tab(window2, pane2, project.name, { cwd = project.path })
					end
				end),
				title = "Select a Project",
				choices = choices,
			}),
			pane
		)
	end)
end
return M
