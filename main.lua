-- main.lua
-- first try

local physics = require("physics")
local sprite = require("sprite")

local enemy = require("enemy")

local game = display.newGroup();
game.x = 0

physics.start()

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 200)

physics.setDrawMode("hybrid") --Set physics Draw mode
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

--[[local circle = display.newCircle(enemy.x, enemy.y, 50)
circle:setFillColor(0,255,0)
circle.alpha = 0.4]]

local enemyBody = {density = 1.5, friction = 0.7, bounce = 0.3, radius = 50, isSensor = true}

local enemy1 = enemy.newEnemy(150, 150)
local loc = enemy1:getLocation()
game:insert(enemy1); enemy1.id = "enemy1"; enemy1.x = loc.x; enemy1.y = loc.y;
physics.addBody(enemy1, enemyBody)

local enemy2 = enemy.newEnemy(350, 350)
game:insert(enemy2); enemy2.id = "enemy2"; enemy2.x = 350; enemy2.y = 350; 
physics.addBody(enemy2, enemyBody)

local function onCollide(event)
	if((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "began") then
		background:setFillColor(255,0,0)
	elseif((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end
end

local function playerTouch(event)
    --player:applyLinearImpulse((event.x - player.x) * .5, (event.y - player.y) * .5, player.x, player.y)
	player.x = event.x
	player.y = event.y
	enemy1:setLocation({x = enemy1.x + event.x, y = enemy1.y + event.y})
end

background:addEventListener("touch", playerTouch)

Runtime:addEventListener("collision", onCollide)
