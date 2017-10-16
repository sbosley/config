hs.window.animationDuration = 0

function adjustWindowFrame(transform)
  if not transform then return end

  local win = hs.window.focusedWindow()
  local winFrame = win:frame()

  transform(winFrame, win:screen():frame())
  win:setFrame(winFrame)
end

function fillFrame(after)
  adjustWindowFrame(function(win, screen)
    win.x = screen.x
    win.y = screen.y
    win.w = screen.w
    win.h = screen.h
    if after then after(win, screen) end
  end)
end

pushModifiers = {"ctrl", "cmd"}
hs.hotkey.bind(pushModifiers, "L", function()
  fillFrame(function(win, screen)
    win.x = screen.x + (screen.w / 2)
    win.w = screen.w / 2
  end)
end)

hs.hotkey.bind(pushModifiers, "J", function()
  fillFrame(function(win, screen)
    win.w = screen.w / 2
  end)
end)

hs.hotkey.bind(pushModifiers, "I", function()
  fillFrame(function (win, screen)
    win.h = screen.h / 2
  end)
end)

hs.hotkey.bind(pushModifiers, ",", function()
  fillFrame(function (win, screen)
    win.y = screen.y + (screen.h / 2)
    win.h = screen.h / 2
  end)
end)

function move(dim, getNewOrigin)
  local movePercentage = 5
  local moveDivisor = 100 / movePercentage
  adjustWindowFrame(function(win, screen)
    if (dim == "x") then
      win.x = getNewOrigin(screen.w / moveDivisor, win.x, win.w, screen.x, screen.w)
    else
      win.y = getNewOrigin(screen.h / moveDivisor, win.y, win.h, screen.y, screen.h)
    end
  end)
end

function movePositive(dim)
  move(dim, function(moveAmount, winOrigin, winSize, screenOrigin, screenSize)
    return math.min(winOrigin + moveAmount, screenOrigin + screenSize - winSize)
  end)
end

function moveNegative(dim)
  move(dim, function(moveAmount, winOrigin, winSize, screenOrigin, screenSize)
    return math.max(winOrigin - moveAmount, screenOrigin)
  end)
end

moveModifiers = {"shift", "alt"}
hs.hotkey.bind(moveModifiers, "L", function()
  movePositive("x")
end)

hs.hotkey.bind(moveModifiers, ",", function()
  movePositive("y")
end)

hs.hotkey.bind(moveModifiers, "J", function()
  moveNegative("x")
end)

hs.hotkey.bind(moveModifiers, "I", function()
  moveNegative("y")
end)

function resize(dim, getNewSize)
  local resizePercentage = 5
  local resizeDivisor = 100 / resizePercentage
  adjustWindowFrame(function(win, screen)
    if (dim == "x") then
      win.w = getNewSize(screen.w / resizeDivisor, win.x, win.w, screen.x, screen.w)
    else
      win.h = getNewSize(screen.h / resizeDivisor, win.y, win.h, screen.y, screen.h)
    end
  end)
end

function resizePositive(dim)
  resize(dim, function(resizeAmount, winOrigin, winSize, screenOrigin, screenSize)
    return math.min(winSize + resizeAmount, screenOrigin + screenSize - winOrigin)
  end)
end

function resizeNegative(dim)
  resize(dim, function(resizeAmount, winOrigin, winSize, screenOrigin, screenSize)
    return math.max(winSize - resizeAmount, resizeAmount)
  end)
end

resizePositiveModifiers = {"cmd", "alt"}
hs.hotkey.bind(resizePositiveModifiers, "L", function()
  resizePositive("x")
end)

hs.hotkey.bind(resizePositiveModifiers, ",", function()
  resizePositive("y")
end)

hs.hotkey.bind(resizePositiveModifiers, "J", function()
  resizeNegative("x")
end)

hs.hotkey.bind(resizePositiveModifiers, "I", function()
  resizeNegative("y")
end)

function throw(screenNumber)
  local screens = hs.screen.allScreens()
  if screenNumber > #screens then return end

  hs.window.focusedWindow():moveToScreen(screens[screenNumber])
  fillFrame(nil)
end

throwModifiers = {"cmd", "alt"}
hs.hotkey.bind(throwModifiers, "1", function() throw(1) end)
hs.hotkey.bind(throwModifiers, "2", function() throw(2) end)
hs.hotkey.bind(throwModifiers, "3", function() throw(3) end)
