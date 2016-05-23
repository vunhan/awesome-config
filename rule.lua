-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:fdm=marker:foldmarker={{{,}}}
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- Set urxvt transparent
    { rule = { class = "urxvt" },
      properties = { opacity = 0.1 } },
    -- Set Firefox to always map on tags number 2 of last screen
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "chromium" },
      properties = { tag = tags[screen.count()][2] } },
    -- Plugin of firefox must be floating window
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    -- DownThemAll Manager must be floating window
    { rule = { instance = "DTA" },
      properties = { floating = true } },
    -- mpv must be floating window
    { rule = { class = "mpv" },
      properties = { floating = true } },
    -- Set Steam to always map on tags number 7 of first screen
    { rule = { class = "Steam" },
      properties = { tag = tags[1][7] } },
    -- Set Zim to always map on tags number 5 of last screen
    { rule = { class = "Zim" },
      properties = { tag = tags[screen.count()][5] } },
    -- Set Desktop of Gnome must be share all workspace
    { rule = { class = "Nautilus", instance = "desktop_window" },
      properties = { sticky = true } },
    -- Set File manager of Gnome to always map on tags number 4 of last screen
    { rule = { class = "Nautilus", instance = "nautilus" },
      properties = { tag = tags[screen.count()][4] } },
    -- feh must be floating window
    { rule = { class = "feh" },
      properties = { floating = true } },
    -- Set WPS Office to always map on tags number 3 of last screen
    { rule = { class = "Et" },
      properties = { tag = tags[screen.count()][3] } },
}
