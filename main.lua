-- main.lua
-- first try

local physics = require("physics")
local sprite = require("sprite")

physics.start()

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 200)

--physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight --Screen Size properties
local playerSheet = sprite.newSpriteSheet("ball_white.png", 72, 72)
local playerSet = sprite.newSpriteSet(playerSheet, 1, 1)
sprite.add(playerSet, "def", 1, 1, 1000)
local player = sprite.newSprite(playerSet)
player.x = display.contentWidth / 2
player.y = display.contentHeight / 2
player.xScale = 0.5
player.yScale = 0.5

player:prepare("def")
player:play()

local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
physics.addBody(player, playerBody)

local function playerTouch(event)
    player:applyLinearImpulse((event.x - player.x) * .5, (event.y - player.y) * .5, player.x, player.y)
end
background:addEventListener("touch", playerTouch)
