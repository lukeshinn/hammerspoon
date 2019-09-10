--MODIFIERS
---------------------------------------------------------------------------
hyper = {"cmd",  "shift"}
hypershift = {"cmd", "shift", "alt"}

hs.hotkey.bind(hyper, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- SCREENS
---------------------------------------------------------------------------
-- push window one screen left
hs.hotkey.bind(hyper, "x", function()
  moveWindowToScreen("left")
end)

-- push window one screen right
hs.hotkey.bind(hyper, "b", function()
  moveWindowToScreen("right")
end)

-- apply layout
hs.hotkey.bind(hyper, "y", function()
  applyWindowLayout()
end)

-- Misc
---------------------------------------------------------------------------
-- draw crosshair
hs.hotkey.bind(hyper, "z", function()
  updateCrosshairs()
end)

-- remove crosshair
hs.hotkey.bind(hypershift, "z", function()
  clearCrosshairs()
end)
