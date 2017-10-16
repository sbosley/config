hs.window.animationDuration = 0

function adjustWindowFrame(transform)
  if transform == nil then return end

  local win = hs.window.focusedWindow():frame()
  local screen = win:screen():frame()

  transform(f, screen)
  win:setFrame(f)
end

function fillFrame(post)
  adjustWindowFrame(function(win, screen)
    win.x = screen.x
    win.y = screen.y
    win.w = screen.w
    win.h = screen.h
  end)
  if post != nil then post(win, screen) end
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

resizePositiveModifiers = {"cmd", "alt"}
resizePercentage = 5
resizeDivisor = 100 / resizePercentage

function xResizeAmount(screen)
  return screen.w / resizeDivisor
end

function yResizeAmount(screen)
  return screen.h / resizeDivisor
end

hs.hotkey.bind(resizePositiveModifiers, "L", function()
  adjustWindowFrame(function(win, screen)
    local newW = win.w + xResizeAmount(screen)
    if win.x + newW > screen.x + screen.w then
      newW = screen.x + screen.w - win.x
    end
    win.w = newW
  end)
end)

hs.hotkey.bind(resizePositiveModifiers, "J", function()
  adjustWindowFrame(function(win, screen)
    local xResize = xResizeAmount(screen)
    local newW = win.w - xResize
    if newW < xResize then
      newW = xResize
    end
    win.w = newW
  end)
end)

hs.hotkey.bind(resizePositiveModifiers, "I", function()
  adjustWindowFrame(function(win, screen)
    local yResize = yResizeAmount(screen)
    local newH = win.h - yResize
    if newH < yResize then
      newH = yResize
    end
    win.h = newH
  end)
end)

hs.hotkey.bind(resizePositiveModifiers, ",", function()
  adjustWindowFrame(function(win, screen)
    local newH = win.h + yResizeAmount(screen)
    if win.y + newH > screen.y + screen.h then
      newH = screen.y + screen.h - win.y
    end
    win.h = newH
  end)
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
