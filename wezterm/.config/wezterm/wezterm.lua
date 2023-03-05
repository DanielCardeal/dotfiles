local wezterm = require 'wezterm'
local act = wezterm.action

return {
    -- ###########
    --    STYLE
    -- ###########
    window_background_opacity = 0.95,
    color_scheme = "Gruvbox dark, hard (base16)",
    font_size = 13,
    colors = {
        cursor_bg = "fe8019", -- laranja gruvbox
    },
    -- ###################
    --    WINDOW LAYOUT
    -- ###################
    hide_tab_bar_if_only_one_tab = true,
    window_decorations = 'NONE',
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    -- #############
    --    KEYMAPS
    -- #############
    leader = { key = 'h', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = {
        -- SPLITS
        { key = 'v', mods = 'LEADER', action = act.SplitHorizontal },
        { key = 's', mods = 'LEADER', action = act.SplitVertical },
        -- PANES
        { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
        -- TABS
        { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
        { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
    }
}
