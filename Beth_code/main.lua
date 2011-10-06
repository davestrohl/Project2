--load external modules
local physics = require("physics")
local level1map = require("level1map")
--local level2map = require("level2map")

--some setup stuff
physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight

--level boolean switches
local load_level1map = false
local load_level2map = false

--loadNext() determine which levelmap to load
local loadNext = function(event)
    if next_level == "level1map" then
        load_level1map=true
    elseif next_level == "level2map" then
        load_level2map = true
    end
end

--gameListener() the app's main enterFrame listener
-- note: NOT local
gameListener = function(event)

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
    load_level1map = true --load first level
end

loadApp()