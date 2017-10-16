hs.window.animationDuration = 0

function adjustWindowFrame(transform)
  if transform == nil then return end

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

moveModifiers = {"shift", "alt"}
movePercentage = 5
moveDivisor = 100 / movePercentage
function xNudgeAmount(screen)
  return screen.w / moveDivisor
end

function yNudgeAmount(screen)
  return screen.h / moveDivisor
end

hs.hotkey.bind(moveModifiers, "L", function()
  adjustWindowFrame(function (win, screen)
    local newX = win.x + xNudgeAmount(screen)
    if newX + win.w > screen.x + screen.w then
      newX = screen.x + screen.w - win.w
    end
    win.x = newX
  end)
end)

hs.hotkey.bind(moveModifiers, "J", function()
  adjustWindowFrame(function (win, screen)
    local newX = win.x - xNudgeAmount(screen)
    if newX < screen.x then
      newX = screen.x
    end
    win.x = newX
  end)
end)

hs.hotkey.bind(moveModifiers, "I", function()
  adjustWindowFrame(function (win, screen)
    local newY = win.y - yNudgeAmount(screen)
    if newY < screen.y then
      newY = screen.y
    end
    win.y = newY
  end)
end)

hs.hotkey.bind(moveModifiers, ",", function()
  adjustWindowFrame(function (win, screen)
    local newY = win.y + yNudgeAmount(screen)
    if newY + win.y > screen.y + screen.h then
      newY = screen.y + screen.h - win.h
    end
    win.y = newY
  end)
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
