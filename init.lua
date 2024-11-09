hs.window.animationDuration = 0
log = hs.logger.new("config")

roon = require("roon")

function pushWindow(rect)
  return function() hs.window.focusedWindow():moveToUnit(rect) end
end

function moveWindow(delta)
  return function() hs.window.focusedWindow():move(delta, nil, true) end
end

function resizeWindow(delta)
  return function()
    local win = hs.window.focusedWindow()
    local size = win:size()
    size.w = size.w + delta.x
    size.h = size.h + delta.y
    win:setSize(size)
  end
end

function throwWindow(screenNumber)
  return function()
    local screens = hs.screen.allScreens()
    if screenNumber > #screens then return end

    hs.window.focusedWindow():moveToScreen(screens[screenNumber])
    pushWindow('[0,0 100x100]')()
  end
end

function screenFrame() return hs.window.focusedWindow():screen():frame() end
function incrX() return hs.geometry(screenFrame().w * 5 / 100, 0) end
function decrX() return hs.geometry(screenFrame().w * -5 / 100, 0) end
function incrY() return hs.geometry(0, screenFrame().h * 5 / 100) end
function decrY() return hs.geometry(0, screenFrame().h * -5 / 100) end

function changeRoonVolume(delta)
  return function() roon.changeVolume(delta) end
end

pushModifiers = {"ctrl", "cmd"}
hs.hotkey.bind(pushModifiers, "L", pushWindow('[50,0 50x100]'))
hs.hotkey.bind(pushModifiers, "J", pushWindow('[0,0 50x100]'))
hs.hotkey.bind(pushModifiers, "I", pushWindow('[0,0 100x50]'))
hs.hotkey.bind(pushModifiers, ",", pushWindow('[0,50 100x50]'))
hs.hotkey.bind(pushModifiers, "U", pushWindow('[0,0 50x50]'))
hs.hotkey.bind(pushModifiers, "O", pushWindow('[50,0 50x50]'))
hs.hotkey.bind(pushModifiers, "M", pushWindow('[0,50 50x50]'))
hs.hotkey.bind(pushModifiers, ".", pushWindow('[50,50 50x50]'))
hs.hotkey.bind(pushModifiers, "K", pushWindow('[0,0 100x100]'))

moveModifiers = {"shift", "alt"}
hs.hotkey.bind(moveModifiers, "L", moveWindow(incrX()))
hs.hotkey.bind(moveModifiers, ",", moveWindow(incrY()))
hs.hotkey.bind(moveModifiers, "J", moveWindow(decrX()))
hs.hotkey.bind(moveModifiers, "I", moveWindow(decrY()))

resizeModifiers = {"cmd", "alt"}
hs.hotkey.bind(resizeModifiers, "L", resizeWindow(incrX()))
hs.hotkey.bind(resizeModifiers, ",", resizeWindow(incrY()))
hs.hotkey.bind(resizeModifiers, "J", resizeWindow(decrX()))
hs.hotkey.bind(resizeModifiers, "I", resizeWindow(decrY()))

throwModifiers = {"cmd", "alt"}
hs.hotkey.bind(throwModifiers, "1", throwWindow(1))
hs.hotkey.bind(throwModifiers, "2", throwWindow(2))
hs.hotkey.bind(throwModifiers, "3", throwWindow(3))

volumeModifiers = {"cmd"}
hs.hotkey.bind(volumeModifiers, "f11", changeRoonVolume(-2))
hs.hotkey.bind(volumeModifiers, "f12", changeRoonVolume(2))

bigVolumeModifiers = {"cmd", "alt", "ctrl"}
hs.hotkey.bind(bigVolumeModifiers, "f11", changeRoonVolume(-4))
hs.hotkey.bind(bigVolumeModifiers, "f12", changeRoonVolume(4))
