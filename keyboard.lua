-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:fdm=marker:foldmarker={{{,}}}
-- Scratch drop
local drop = require("drop")
-- Vicious
local vicious = require("vicious")

-- Global keys
globalkeys = awful.util.table.join(

    -- Workspace browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- Screen move
    awful.key({ modkey, "Control" }, "Left",   function() awful.screen.focus(mouse.screen - 1) end),
    awful.key({ modkey, "Control" }, "Right",  function() awful.screen.focus(mouse.screen + 1) end),

    -- Client focus
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show menu
    awful.key({ modkey,           }, "F2", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ altkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    --awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- Prompt
    awful.key({ altkey,           }, "F2",    function () mypromptbox[mouse.screen]:run() end),
    awful.key({ altkey,           }, "F3",     dynamo.calculate                               ),
    awful.key({ modkey,           }, "x",     dynamo.quote                                   ),

    -- ALSA volume control
    awful.key({ altkey,           }, "Up",
    function ()
        awful.util.spawn("amixer -q set Master 1%+")
        vicious.force(volume.text)
    end),
    awful.key({ altkey,           }, "Down",
    function ()
        awful.util.spawn("amixer -q set Master 1%-")
        vicious.force(volume.text)
    end),
    awful.key({ altkey,           }, "m",
    function ()
        awful.util.spawn("amixer -q set Master playback toggle")
        vicious.force(volume.text)
    end),
    awful.key({ altkey, "Control" }, "m",
    function ()
        awful.util.spawn("amixer -q set Master playback 100%")
        vicious.force(volume.text)
    end),

    -- MPD control
    awful.key({ altkey, "Control" }, "Up",
    function ()
        awful.util.spawn_with_shell("mpc toggle")
        vicious.force(mpd.text)
    end),
    awful.key({ altkey, "Control" }, "Down",
    function ()
        awful.util.spawn_with_shell("mpc stop")
        vicious.force(mpd.text)
    end),
    awful.key({ altkey, "Control" }, "Left",
    function ()
        awful.util.spawn_with_shell("mpc prev")
        vicious.force(mpd.text)
    end),
    awful.key({ altkey, "Control" }, "Right",
    function ()
        awful.util.spawn_with_shell("mpc next")
        vicious.force(mpd.text)
    end),

    -- Dropdown terminal
    awful.key({ modkey,           }, "z",     function () drop(terminal)  end),
    -- Redshift
    awful.key({ modkey,           }, "d",     redshift.toggle                ),
    -- Menubar
    awful.key({ modkey,           }, "p",     function () menubar.show()  end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ altkey,           }, "F4",     function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

-- Set keys
root.keys(globalkeys)