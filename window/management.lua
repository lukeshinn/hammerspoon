local sizes = {2, 3, 3/2}
local fullScreenSizes = {1, 3}
local focusScreenSizes = {1, 4/3, 2, 3}

local GRID = {w = 24, h = 24}
hs.grid.setGrid(GRID.w .. 'x' .. GRID.h)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

local pressed = {
  up = false,
  down = false,
  left = false,
  right = false
}

function nextStep(dim, offs, cb)
  if hs.window.focusedWindow() then
    local axis = dim == 'w' and 'x' or 'y'
    local oppDim = dim == 'w' and 'h' or 'w'
    local oppAxis = dim == 'w' and 'y' or 'x'
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)

    local nextSize = sizes[1]
    for i=1,#sizes do
      if cell[dim] == GRID[dim] / sizes[i] and
        (cell[axis] + (offs and cell[dim] or 0)) == (offs and GRID[dim] or 0)
        then
          nextSize = sizes[(i % #sizes) + 1]
          break
        end
      end

      cb(cell, nextSize)
      if cell[oppAxis] ~= 0 and cell[oppAxis] + cell[oppDim] ~= GRID[oppDim] then
        cell[oppDim] = GRID[oppDim]
        cell[oppAxis] = 0
      end

      hs.grid.set(win, cell, screen)
    end
  end

  function nextFocusScreenStep()
    if hs.window.focusedWindow() then
      local win = hs.window.frontmostWindow()
      local id = win:id()
      local screen = win:screen()

      cell = hs.grid.get(win, screen)

      local nextSize = focusScreenSizes[1]
      for i=1,#focusScreenSizes do
        if cell.w == GRID.w / focusScreenSizes[i] and
          cell.h == GRID.h / focusScreenSizes[i] and
          cell.x == (GRID.w - GRID.w / focusScreenSizes[i]) / 2 and
          cell.y == (GRID.h - GRID.h / focusScreenSizes[i]) / 2 then
          nextSize = focusScreenSizes[(i % #focusScreenSizes) + 1]
          break
        end
      end

      cell.w = GRID.w / nextSize
      cell.h = GRID.h / nextSize
      cell.x = (GRID.w - GRID.w / nextSize) / 2
      cell.y = (GRID.h - GRID.h / nextSize) / 2

      hs.grid.set(win, cell, screen)
    end
  end

  function nextFullScreenStep()
    if hs.window.focusedWindow() then
      local win = hs.window.frontmostWindow()
      local id = win:id()
      local screen = win:screen()

      cell = hs.grid.get(win, screen)

      local nextSize = fullScreenSizes[1]
      for i=1,#fullScreenSizes do
        if cell.w == GRID.w / fullScreenSizes[i] and
          -- cell.h == GRID.h / fullScreenSizes[i] and
          cell.x == (GRID.w - GRID.w / fullScreenSizes[i]) / 2 then
          -- cell.y == (GRID.h - GRID.h / fullScreenSizes[i]) / 2 then
          nextSize = fullScreenSizes[(i % #fullScreenSizes) + 1]
          break
        end
      end

      cell.w = GRID.w / nextSize
      cell.h = GRID.h / nextSize
      cell.x = (GRID.w - GRID.w / nextSize) / 2
      cell.y = (GRID.h - GRID.h / nextSize) / 2

      -- override height and y so that it is always 100% tall
      cell.h = 100
      cell.y = 0

      hs.grid.set(win, cell, screen)
    end
  end

  function fullDimension(dim)
    if hs.window.focusedWindow() then
      local win = hs.window.frontmostWindow()
      local id = win:id()
      local screen = win:screen()
      cell = hs.grid.get(win, screen)

      if (dim == 'x') then
        cell = '0,0 ' .. GRID.w .. 'x' .. GRID.h
      else
        cell[dim] = GRID[dim]
        cell[dim == 'w' and 'x' or 'y'] = 0
      end

      hs.grid.set(win, cell, screen)
    end
  end

  hs.hotkey.bind(hyper, "C", function ()
    pressed.down = true
    if pressed.up then
      fullDimension('h')
    else
      nextStep('h', true, function (cell, nextSize)
        cell.y = GRID.h - GRID.h / nextSize
        cell.h = GRID.h / nextSize
      end)
    end
  end, function ()
  pressed.down = false
end)

hs.hotkey.bind(hyper, "F", function ()
  pressed.right = true
  if pressed.left then
    fullDimension('w')
  else
    nextStep('w', true, function (cell, nextSize)
      cell.x = GRID.w - GRID.w / nextSize
      cell.w = GRID.w / nextSize
    end)
  end
end, function ()
pressed.right = false
end)

hs.hotkey.bind(hyper, "S", function ()
  pressed.left = true
  if pressed.right then
    fullDimension('w')
  else
    nextStep('w', false, function (cell, nextSize)
      cell.x = 0
      cell.w = GRID.w / nextSize
    end)
  end
end, function ()
pressed.left = false
end)

hs.hotkey.bind(hyper, "E", function ()
  pressed.up = true
  if pressed.down then
    fullDimension('h')
  else
    nextStep('h', false, function (cell, nextSize)
      cell.y = 0
      cell.h = GRID.h / nextSize
    end)
  end
end, function ()
pressed.up = false
end)

hs.hotkey.bind(hyper, "G", function ()
  nextFullScreenStep()
end)

-- hs.hotkey.bind(hypershift, "T", function()
--   nextFocusScreenStep()
-- end)

hs.hotkey.bind(hyper, "i", function ()
  local win = hs.window.frontmostWindow()
  local id = win:id()
  local screen = win:screen()
  cell = hs.grid.get(win, screen)
  hs.alert.show(cell)
end)
