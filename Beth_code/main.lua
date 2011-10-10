--load external modules
local physics = require("physics")
local level1map = require("level1map")
local menu = require("menu")
--local level2map = require("level2map")
------------------------------------------------------------
--some global variables
next_level=""
disguise = ""
-----------------------------------------------------
--some setup stuff
display.setStatusBar( display.HiddenStatusBar )
local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight

-- UI buttons -add buttons for moving map
local button_maker = function()
    top_button = display.newRect(190,0, 100, 20)
    bottom_button = display.newRect(190,854,100,-20)
    left_button = display.newRect(0,427,20,100)
    right_button = display.newRect(480,427, -20, 100)
end

    
--level boolean switches
local load_menu = false
local load_level1map = false
--local load_level2map = false

--loadNext() determine which levelmap to load
local loadNext = function(event)
    print(next_level)
    if next_level == "menu" then
        load_menu = true
    elseif next_level == "level1map" then
        button_maker()
        load_level1map=true
    -- elseif next_level == "level2map" then
        -- load_level2map = true
    end
end

--gameListener() the app's main enterFrame listener
-- note: NOT local
gameListener = function(event)

--MENU
    if load_menu then
        load_menu = false
        menu:menu() -- call init (named menu in this case)
    end
    if menu.callUnload then
        menu.callUnload = false
        next_level = menu.unloadMe()
        loadNext()
    end

--LEVEL 1 MAP
    if load_level1map then
        load_level1map =  false --reset switch
        level1map:init() --call init function
    end
    if level1map.callUnload then
        level1map.callUnload = false --reset switch
        level1map:unloadMe() -- call unload function
        loadNext() -- load next levelmap
    end

--LEVEL 2 MAP
    -- if load_level2map then
        -- load_level2map = false
        -- level2map:init()
    -- end
    -- if level2map.callUnload then
        -- level2map.callUnload = false
        -- level2map.unloadMe()
        -- loadNext()
    -- end
end

-- loadApp() initializeds the game

local loadApp = function()
    --start the listener for level changes
    Runtime:addEventListener("enterFrame", gameListener)
    print(next_level)
    --load_level1map = true --load first level
    load_menu = true --load menu screen
end
loadApp()