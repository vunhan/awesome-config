-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:fdm=marker:foldmarker={{{,}}}
-- Notification library
local naughty = require("naughty")
-- Lua to HTML library
local html = require("html")
-- Vicious library
local vicious = require("vicious")
local wibox = require("wibox")

-- {{{ Calculation
dynamo.calculate = function ()
    prompt.text:set_markup(html(beautiful.fg_command ," Máy tính"))
    vicious.unregister(prompt.text)
    awful.prompt.run({ prompt = "" },
                     mypromptbox[mouse.screen].widget,
                     function (expr) -- Execute callback
                         vicious.register(prompt.text, vicious.widgets.os, html(beautiful.fg_command, " $3@$4"))
                         local result = awful.util.eval("return (" .. trim(expr) .. ")")
                         naughty.notify({ text = html(beautiful.fg_focus, expr .. " = " .. result), timeout = 10, screen = mouse.screen })
                     end,
                     nil, -- Complete callback
                     awful.util.getdir("cache") .. "/history_calc",
                     nil,
                     function (expr) -- Done callback
                         vicious.register(prompt.text, vicious.widgets.os, html(beautiful.fg_command, " $3@$4"))
                     end)
end
-- }}}

-- {{{ Quote
dynamo.quote = function ()
    local result = awful.util.pread("fortune")
    naughty.notify({ text = result, timeout = 10, screen = mouse.screen })
end
-- }}}

-- {{{ Turn on/off touchpad
local touchpad_state = 1
dynamo.touchpad_toggle = function()
    awful.util.spawn_with_shell("synclient TouchpadOff=" .. touchpad_state)
    if touchpad_state == 1 then
        naughty.notify({ text = "Tắt touchpad", timeout = 1, screen = mouse.screen })
        touchpad_state = 0
    else
        naughty.notify({ text = "Bật touchpad", timeout = 1, screen = mouse.screen })
        touchpad_state = 1
    end
end
-- }}}

-- {{{ Show properties of windows
dynamo.xprop = function()
    --local result = awful.util.pread("xprop")
    --naughty.notify({ text = result, timeout = 10, screen = mouse.screen })
    mousegrabber.run(function(_mouse)
        for k, v in ipairs(_mouse.buttons) do
            if v then
                local c = client.focus
                local result = {
                    name = c.name,
                    class = c.class,
                    instance = c.instance,
                    type = c.type,
                    window = c.window,
                    role = c.role,
                }
                dbg(result, true)
                return false
            end
            return true
        end
    end, "target")
end
-- }}}

-- {{{ Show popup
local dynamo_popup = nil

local function hide_popup(is_widget)
    if dynamo_popup ~= nil then
        if is_widget then
            dynamo_popup.visible = false
            dynamo_popup = nil
        else
            naughty.destroy(dynamo_popup)
        end
        dynamo_popup = nil
    end
end

local function show_popup(is_widget, result)
    hide_popup(is_widget)
    if is_widget then
        dynamo_popup = wibox({ height = 300, width = 500, ontop = true, x = 1000, y = 18})
        dynamo_popup:set_widget(result)
        dynamo_popup.visible = true
    else
        dynamo_popup = naughty.notify({ text = result, timeout = 0, hover_timeout = 0.5, screen = mouse.screen })
    end
end

dynamo.popup = function(widget, callback, args)
    local original_args = args
    local args = args or {}
    local result = nil
    local is_widget = false
    if type(callback) == "function" then
        result = callback(args)
    elseif type(callback) == "table" then
        for k, v in pairs(callback) do
            if k == "draw" then
                is_widget = true
                break
            end
        end
        if is_widget then -- Table is a widget
            if original_args == nil then
                result = callback
            else
                result = callback(args)
            end
        else -- Table is normal array
            result = callback
        end
    elseif type(callback) == "string" or type(callback) == "number" then
        result = callback
    end
    widget:connect_signal("mouse::enter", function() show_popup(is_widget, result) end)
    widget:connect_signal("mouse::leave", function() hide_popup(is_widget) end)
end
-- }}}
