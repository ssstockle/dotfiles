local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 9.5 
config.initial_cols = 120
config.initial_rows = 28

config.window_decorations = "NONE"
config.enable_tab_bar = false
config.window_background_opacity = 0.90

config.window_frame = {
  font = wezterm.font 'JetBrains Mono',
  font_size = 9.5,
}

config.force_reverse_video_cursor = true

-- Grayscale color scheme
config.colors = {
  foreground = '#d0d0d0',
  background = '#000000',
  cursor_bg = '#ffffff',
  cursor_fg = '#000000',
  selection_bg = '#444444',
  selection_fg = '#ffffff',
  ansi = {
    '#000000', '#555555', '#777777', '#999999',
    '#aaaaaa', '#bbbbbb', '#cccccc', '#eeeeee',
  },
  brights = {
    '#333333', '#555555', '#777777', '#999999',
    '#aaaaaa', '#bbbbbb', '#cccccc', '#ffffff',
  },
}

return config
