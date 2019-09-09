-- CONFIG
hs.application.enableSpotlightForNameSearches(true)
hs.window.animationDuration = 0
hs.window.setShadows = "false"
hs.hints.fontName           = "Hack"
hs.hints.fontSize           = 22
hs.hints.showTitleThresh    = 0
hs.hints.hintChars          = { 'A', 'S', 'D', 'F', 'G', 'Q', 'W', 'E', 'R', 'T', 'Z', 'X', 'C', 'V', 'B' }
hs.console.clearConsole()

-- REQUIRES
---------------------------------------------------------------------------
require("bindings.init")

-- window
require("window.layout")
require("window.management")

-- menubar
require("menubar")

-- apps
require("apps.crosshair")

-- screens
require("window.screens.move-window")
