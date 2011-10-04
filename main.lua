--Declarations - variables/switches/etc
--level boolean switches
local load_level1map = false
local load_level2map = false

--load external modules
local level1map = require("level1map")
local level2map = require("level2map")

--loadNext() determine which levelmap to load
local loadNext = function(event)
    if next_level == "level1map" then
        load_level1map=true
    elseif next_level = "level2map" then
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
    if load_level2map then
        load_level2map = false
        level2map:init()
    end
    if level2map.callUnload then
        level2map.callUnload = false
        level2map.unloadMe()
        loadNext()
    end
end

-- loadApp() initializeds the game

local loadApp = function()
    --start the listener for level changes
    Runtime:addEventListener("enterFrame", gameListener)
    load_level1map = true --load first level
end

loadApp()

-- main.lua
-- first try

-- local physics = require("physics")
-- local sprite = require("sprite")

-- physics.start()

-- local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
-- background:setFillColor(0, 0, 200)

-- physics.setDrawMode("hybrid") --Set physics Draw mode
-- physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
-- physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector
-- display.setStatusBar( display.HiddenStatusBar )

-- local screenW, screenH = display.contentWidth, display.contentHeight
-- local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight --Screen Size properties
-- local playerSheet = sprite.newSpriteSheet("ball_white.png", 72, 72)
-- local playerSet = sprite.newSpriteSet(playerSheet, 1, 1)
-- sprite.add(playerSet, "def", 1, 1, 1000)
-- local player = sprite.newSprite(playerSet)
-- player.x = display.contentWidth / 2
-- player.y = display.contentHeight / 2
-- player.xScale = 0.5
-- player.yScale = 0.5

-- player:prepare("def")
-- player:play()

-- local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
-- physics.addBody(player, playerBody)

-- local function playerTouch(event)
    -- player:applyLinearImpulse((event.x - player.x) * .5, (event.y - player.y) * .5, player.x, player.y)
-- end
-- background:addEventListener("touch", playerTouch)
