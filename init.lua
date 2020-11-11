hs.window.animationDuration = 0

function pushWindow(rect)
  hs.window.focusedWindow():moveToUnit(rect)
end

function moveWindow(delta)
  hs.window.focusedWindow():move(delta, nil, true)
end

function resizeWindow(delta)
  local win = hs.window.focusedWindow()
  local size = win:size()
  size.w = size.w + delta.x
  size.h = size.h + delta.y
  win:setSize(size)
end

function throwWindow(screenNumber)
  local screens = hs.screen.allScreens()
  if screenNumber > #screens then return end

  hs.window.focusedWindow():moveToScreen(screens[screenNumber])
  pushWindow('[0,0 100x100]')
end

function increment(dir)
  local screen = hs.window.focusedWindow():screen():frame()
  if dir == "x" then
    return screen.w * 5 / 100
  else
    return screen.h * 5 / 100
  end
end

function plusX() return hs.geometry(increment("x"), 0) end
function minusX() return hs.geometry(-1*increment("x"), 0) end
function plusY() return hs.geometry(0, increment("y")) end
function minusY() return hs.geometry(0, -1*increment("y")) end

pushModifiers = {"ctrl", "cmd"}
hs.hotkey.bind(pushModifiers, "L", function() pushWindow('[50,0 50x100]') end)
hs.hotkey.bind(pushModifiers, "J", function() pushWindow('[0,0 50x100]') end)
hs.hotkey.bind(pushModifiers, "I", function() pushWindow('[0,0 100x50]') end)
hs.hotkey.bind(pushModifiers, ",", function() pushWindow('[0,50 100x50]') end)
hs.hotkey.bind(pushModifiers, "U", function() pushWindow('[0,0 50x50]') end)
hs.hotkey.bind(pushModifiers, "O", function() pushWindow('[50,0 50x50]') end)
hs.hotkey.bind(pushModifiers, "M", function() pushWindow('[0,50 50x50]') end)
hs.hotkey.bind(pushModifiers, ".", function() pushWindow('[50,50 50x50]') end)
hs.hotkey.bind(pushModifiers, "K", function() pushWindow('[0,0 100x100]') end)

moveModifiers = {"shift", "alt"}
hs.hotkey.bind(moveModifiers, "L", function() moveWindow(plusX()) end)
hs.hotkey.bind(moveModifiers, ",", function() moveWindow(plusY()) end)
hs.hotkey.bind(moveModifiers, "J", function() moveWindow(minusX()) end)
hs.hotkey.bind(moveModifiers, "I", function() moveWindow(minusY()) end)

resizeModifiers = {"cmd", "alt"}
hs.hotkey.bind(resizeModifiers, "L", function() resizeWindow(plusX()) end)
hs.hotkey.bind(resizeModifiers, ",", function() resizeWindow(plusY()) end)
hs.hotkey.bind(resizeModifiers, "J", function() resizeWindow(minusX()) end)
hs.hotkey.bind(resizeModifiers, "I", function() resizeWindow(minusY()) end)

throwModifiers = {"cmd", "alt"}
hs.hotkey.bind(throwModifiers, "1", function() throw(1) end)
hs.hotkey.bind(throwModifiers, "2", function() throw(2) end)
hs.hotkey.bind(throwModifiers, "3", function() throw(3) end)
hs.hotkey.bind(throwModifiers, "4", function() hs.application.find("Roon"):activate() end)
