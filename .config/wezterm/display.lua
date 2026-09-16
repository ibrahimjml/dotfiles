local wezterm = require("wezterm")
local background = require("background")
local M = {}

function M.setup(config)
	-- Appearance
	config.font = wezterm.font("JetBrains Mono", { weight = "DemiBold" })
	config.font_size = 13.0
	config.color_scheme = "tokyonight"

	-- Tab bar settings
	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = false

	-- Window settings
	config.window_decorations = "RESIZE"
	config.window_frame = {
		active_titlebar_bg = "#333333",
		inactive_titlebar_bg = "#222222",
	}
	config.window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}
	config.window_background_image = background.bg_image
	config.window_background_opacity = 0.9 -- lower = more transparent
	config.initial_cols = 120
	config.initial_rows = 30
	config.warn_about_missing_glyphs = false
end

return M
