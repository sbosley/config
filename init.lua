hs.window.animationDuration = 0
log = hs.logger.new("config")

incrPct = 5
roon = require("roon")

function pushWindow(rect)
  return function() hs.window.focusedWindow():moveToUnit(rect) end
end

function moveWindow(delta)
  return function()
    local win = hs.window.focusedWindow()
    win:move(delta(win), nil, true)
  end
end

function resizeWindow(delta)
  return function()
    local win = hs.window.focusedWindow()
    local size = win:size()
    local d = delta(win)
    size.w = size.w + d.x
    size.h = size.h + d.y
    win:setSize(size)
  end
end

function changeScreen(screenFunc)
  return function()
    local win = hs.window.focusedWindow()
    win[screenFunc](win)
  end
end

function throwWindow(screenNumber)
  return function()
    local screens = hs.screen.allScreens()
    if screenNumber > #screens then return end

    hs.window.focusedWindow():moveToScreen(screens[screenNumber])
    pushWindow("[0,0 100x100]")()
  end
end

function deltaX(pct)
  return function(win)
    return hs.geometry(win:screen():frame().w * pct / 100, 0)
  end
end

function deltaY(pct)
  return function(win)
    return hs.geometry(0, win:screen():frame().h * pct / 100)
  end
end

function changeRoonVolume(delta)
  return function() roon.changeVolume(delta) end
end

pushModifiers = {"ctrl", "cmd"}
hs.hotkey.bind(pushModifiers, "L", pushWindow("[50,0 50x100]"))
hs.hotkey.bind(pushModifiers, "J", pushWindow("[0,0 50x100]"))
hs.hotkey.bind(pushModifiers, "I", pushWindow("[0,0 100x50]"))
hs.hotkey.bind(pushModifiers, ",", pushWindow("[0,50 100x50]"))
hs.hotkey.bind(pushModifiers, "U", pushWindow("[0,0 50x50]"))
hs.hotkey.bind(pushModifiers, "O", pushWindow("[50,0 50x50]"))
hs.hotkey.bind(pushModifiers, "M", pushWindow("[0,50 50x50]"))
hs.hotkey.bind(pushModifiers, ".", pushWindow("[50,50 50x50]"))
hs.hotkey.bind(pushModifiers, "K", pushWindow("[0,0 100x100]"))
hs.hotkey.bind(pushModifiers, "left", changeScreen("moveOneScreenWest"))
hs.hotkey.bind(pushModifiers, "right", changeScreen("moveOneScreenEast"))

moveModifiers = {"shift", "alt"}
hs.hotkey.bind(moveModifiers, "L", moveWindow(deltaX(incrPct)))
hs.hotkey.bind(moveModifiers, ",", moveWindow(deltaY(incrPct)))
hs.hotkey.bind(moveModifiers, "J", moveWindow(deltaX(-incrPct)))
hs.hotkey.bind(moveModifiers, "I", moveWindow(deltaY(-incrPct)))

resizeModifiers = {"cmd", "alt"}
hs.hotkey.bind(resizeModifiers, "L", resizeWindow(deltaX(incrPct)))
hs.hotkey.bind(resizeModifiers, ",", resizeWindow(deltaY(incrPct)))
hs.hotkey.bind(resizeModifiers, "J", resizeWindow(deltaX(-incrPct)))
hs.hotkey.bind(resizeModifiers, "I", resizeWindow(deltaY(-incrPct)))

throwModifiers = {"cmd", "alt"}
hs.hotkey.bind(throwModifiers, "1", throwWindow(1))
hs.hotkey.bind(throwModifiers, "2", throwWindow(2))
hs.hotkey.bind(throwModifiers, "3", throwWindow(3))

volumeModifiers = {"cmd"}
hs.hotkey.bind(volumeModifiers, "f11", changeRoonVolume(-2))
hs.hotkey.bind(volumeModifiers, "f12", changeRoonVolume(2))
