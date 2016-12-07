hs.window.animationDuration = 0

function adjustWindowFrame(transform)
    if transform == nil then return end

    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    transform(f, max)
    win:setFrame(f)
end

pushModifiers = {"ctrl", "cmd"}

hs.hotkey.bind(pushModifiers, "L", function()
    adjustWindowFrame(function (f, max)
        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
    end)
end)

hs.hotkey.bind(pushModifiers, "J", function()
    adjustWindowFrame(function (f, max)
        f.x = max.x
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
    end)
end)

hs.hotkey.bind(pushModifiers, "I", function()
    adjustWindowFrame(function (f, max)
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h / 2
    end)
end)

hs.hotkey.bind(pushModifiers, ",", function()
    adjustWindowFrame(function (f, max)
        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w
        f.h = max.h / 2
    end)
end)

moveModifiers = {"shift", "alt"}
movePercentage = 5
moveDivisor = 100 / movePercentage
function xNudgeAmount(max)
    return max.w / moveDivisor
end

function yNudgeAmount(max)
    return max.h / moveDivisor
end

hs.hotkey.bind(moveModifiers, "L", function()
    adjustWindowFrame(function (f, max)
        local newX = f.x + xNudgeAmount(max)
        if newX + f.w > max.x + max.w then
            newX = max.x + max.w - f.w
        end
        f.x = newX
    end)
end)

hs.hotkey.bind(moveModifiers, "J", function()
    adjustWindowFrame(function (f, max)
        local newX = f.x - xNudgeAmount(max)
        if newX < max.x then
            newX = max.x
        end
        f.x = newX
    end)
end)

hs.hotkey.bind(moveModifiers, "I", function()
    adjustWindowFrame(function (f, max)
        local newY = f.y - yNudgeAmount(max)
        if newY < max.y then
            newY = max.y
        end
        f.y = newY
    end)
end)

hs.hotkey.bind(moveModifiers, ",", function()
    adjustWindowFrame(function (f, max)
        local newY = f.y + yNudgeAmount(max)
        if newY + f.y > max.y + max.h then
            newY = max.y + max.h - f.h
        end
        f.y = newY
    end)
end)

resizePositiveModifiers = {"cmd", "alt"}
resizePercentage = 5
resizeDivisor = 100 / resizePercentage

function xResizeAmount(max)
    return max.w / resizeDivisor
end

function yResizeAmount(max)
    return max.h / resizeDivisor
end

hs.hotkey.bind(resizePositiveModifiers, "L", function()
    adjustWindowFrame(function(f, max)
        local newW = f.w + xResizeAmount(max)
        if f.x + newW > max.x + max.w then
            newW = max.x + max.w - f.x
        end
        f.w = newW
    end)
end)

hs.hotkey.bind(resizePositiveModifiers, "J", function()
    adjustWindowFrame(function(f, max)
        local xResize = xResizeAmount(max)
        local newW = f.w - xResize
        if newW < xResize then
            newW = xResize
        end
        f.w = newW
    end)
end)

hs.hotkey.bind(resizePositiveModifiers, "I", function()
    adjustWindowFrame(function(f, max)
        local yResize = yResizeAmount(max)
        local newH = f.h - yResize
        if newH < yResize then
            newH = yResize
        end
        f.h = newH


    end)
end)

hs.hotkey.bind(resizePositiveModifiers, ",", function()
    adjustWindowFrame(function(f, max)
        local newH = f.h + yResizeAmount(max)
        if f.y + newH > max.y + max.h then
            newH = max.y + max.h - f.y
        end
        f.h = newH
    end)
end)

function throw(screenNumber)
    local screens = hs.screen.allScreens()
    if screenNumber > #screens then return end

    hs.window.focusedWindow():moveToScreen(screens[screenNumber])
    adjustWindowFrame(function(f, max)
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h
    end)
end

throwModifiers = {"cmd", "alt"}

hs.hotkey.bind(throwModifiers, "1", function() throw(1) end)
hs.hotkey.bind(throwModifiers, "2", function() throw(2) end)
hs.hotkey.bind(throwModifiers, "3", function() throw(3) end)
