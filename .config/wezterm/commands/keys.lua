local wezterm = require("wezterm")
local helper = require("projects.helper")
local M = {}

function M.setup_keys()
	local keys = {
		-- Paste from clipboard
		{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },

		-- Window Modification
		{ key = "F10", action = wezterm.action.Hide },
		{ key = "F11", action = wezterm.action.ToggleFullScreen },

		-- Add a new tab
		{ key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

		-- Kill / Close the current tab
		{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },

		-- Kill / Close the entire WezTerm application
		{ key = "q", mods = "ALT", action = wezterm.action.QuitApplication },

		-- Toggle the tab bar
		{ key = "b", mods = "ALT", action = wezterm.action.EmitEvent("toggle-tabbar") },

		-- Select Projects Options from helper
		{
			key = "P",
			mods = "ALT|SHIFT",
			action = helper.select_project(),
		},
	}

	-- Quick Switch Tabs: ALT + 1 to 9
	for i = 1, 9 do
		table.insert(keys, {
			key = tostring(i),
			mods = "ALT",
			action = wezterm.action.ActivateTab(i - 1),
		})
	end

	return keys
end

return M
