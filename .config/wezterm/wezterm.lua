local wezterm = require("wezterm")
local config = wezterm.config_builder()
local custom_keys = require("commands.keys")
local display = require("display")

-- Configure appearance settings

display.setup(config)

-- Toggle tab bar visibility

wezterm.on("toggle-tabbar", function(window)
	local overrides = window:get_config_overrides() or {}
	if overrides.enable_tab_bar == false then
		overrides.enable_tab_bar = true
	else
		overrides.enable_tab_bar = false
	end
	window:set_config_overrides(overrides)
end)

-- Configure custom keybindings

config.keys = custom_keys.setup_keys()

return config
