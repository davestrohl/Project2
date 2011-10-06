-- main.lua
-- first try

local physics = require("physics")
local sprite = require("sprite")
--local mc = require("movieclip")

--local enemy = require("enemy")

--local game = display.newGroup();
--game.x = 0
viewRight = {0,0 , 80,-30 , 80,30}
viewLeft = {0,0 , -80,30 , -80,-30}
local enemyBodyLeft = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewLeft}
local enemyBodyRight = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewRight}
Enemy = { x = 0, y = 0 , spr = nil, initDirection = 'r', bound1 = nil, bound2 = nil}
function Enemy:new(x, y)
	self.x = x; self.y = y

	
	local enemySheet = sprite.newSpriteSheet("ball_white.png", 72,72)
	local enemySet = sprite.newSpriteSet(enemySheet, 1, 1)
	sprite.add(enemySet, "patrol", 1, 1, 1000)
	
	local enemy = sprite.newSprite(enemySet)
	enemy.x = x
	enemy.y = y
	enemy.xScale = 0.5
	enemy.yScale = 0.5
    enemy:prepare("patrol")
    enemy:play()
	
	self.spr = enemy
	self.spr.direction = self.initDirection
	
	local object = {x = x, y = y, spr = self.spr, direction = self.spr.direction}
	setmetatable(object, {__index = Enemy})
	self.spr.super = object
	
	return object
end

local function boundCollide(self, event)

	if ((event.other == self.bound1 or event.other == self.bound2) and event.phase == "began") then
					--print(self.super)
					--print(self)
					if(self.direction == 'l') then
						self.direction = 'r'
						self.super.spr.direction = 'r'
					else
						self.direction = 'l'
						self.super.spr.direction = 'l'
					end
					--print(self.super.spr.direction)
					self.super:patrol()
				elseif ((event.other == self.bound1 or event.other == self.bound2) and event.phase == "ended") then
					self:removeSelf()
					physics.addBody(
				
				end
end

function Enemy:spawnBounds( dist )
	local bound1 = display.newRect(self.spr.x - dist.x, self.spr.y, 10, 10)
	physics.addBody(bound1, "static", {bounce = 0.2, isSensor = true})
	self.spr.bound1 = bound1
	local bound2 = display.newRect(self.spr.x + dist.x, self.spr.y, 10, 10)
	physics.addBody(bound2, "static", {bounce = 0.2, isSensor = true})
	self.spr.bound2 = bound2
	--[[local function boundCollide(self, event)
			    
				if ((event.other == self.bound1 or event.other == self.bound2) and event.phase == "began") then
					--print(self.direction)
					if(self.direction == 'l') then
						self.direction = 'r'
						self.super.spr.direction = 'r'
					else
						self.direction = 'l'
						self.super.spr.direction = 'l'
					end
					--print(self.super.spr.direction)
					self.super:patrol()
				elseif ((event.other == self.bound1 or event.other == self.bound2) and event.phase == "ended") then
				
				
				end
		end]]
	--self.spr.collision = boundCollide

	--self.spr:addEventListener("collision", self.spr)
end

function Enemy:getLocation()
	return {x = self.spr.x , y = self.spr.y}
end
	
function Enemy:setLocation( loc )
	self.spr.x = loc.x; self.spr.y = loc.y
end

--function Enemy:get

function Enemy:patrol()
	if(self.spr.direction == 'l') then
		self.spr:setLinearVelocity(-30, 0)
		--self.spr:applyLinearImpulse(math.random(-500, 500), math.random(-500, 500), self.spr.x + math.random(-20, 20), self.spr.y + math.random(-20, 20))
	else
		self.spr:setLinearVelocity(30, 0)
	end
end

--[[function Enemy:changeDirections()
	if(self.direction == 'l') then
		self.direction = 'r'
	else
		self.direction = 'l'
	end
end	]]
		

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

--local enemyBody = {density = 1.5, friction = 0.7, bounce = 0.3, radius = 50, isSensor = false}

local enemy1 = Enemy:new(150, 150)
local loc = enemy1:getLocation()
physics.addBody(enemy1.spr, enemyBodyLeft)
enemy1:spawnBounds({x = 125, y = 0})
enemy1.spr.collision = boundCollide
enemy1.spr:addEventListener("collision", enemy1.spr)
enemy1:patrol()


local enemy2 = Enemy:new(350, 350)
physics.addBody(enemy2.spr, enemyBodyLeft)
enemy2:spawnBounds({x = 100, y = 0})
enemy2.spr.collision = boundCollide
enemy2.spr:addEventListener("collision", enemy2.spr)
enemy2:patrol()


local function onCollide(self, event)
	--[[if((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "began") then
		background:setFillColor(255,0,0)
		enemy1:applyForce(50, -50, enemy1.x, enemy1.y)
	elseif((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end]]
	if((event.other == enemy1.spr or event.other == enemy2.spr) and event.phase == "began") then
		background:setFillColor(255,0,0)
		--enemy2.spr:applyForce(50, -50, enemy1.spr.x, enemy2.spr.y)
	elseif((event.other == enemy1.spr or event.other == enemy2.spr) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end
end

local function onPostCollide(self, event)
	--enemy2.spr:setLinearVelocity(0,0)
	--enemy2:setLocation({x = 350, y = 350})
end

local function playerTouch(event)
    --player:applyLinearImpulse((event.x - player.x) * .5, (event.y - player.y) * .5, player.x, player.y)
	player.x = event.x
	player.y = event.y
	--enemy1:move(50, -50)
	
end

background:addEventListener("touch", playerTouch)
--Runtime:addEventListener("collision", onCollide)
player.collision = onCollide
player:addEventListener("collision", player)
player.postCollision = onPostCollide
player:addEventListener("postCollision", player)
--enemy1.spr.collide = boundCollide
	--print(boundCollide)
--enemy1.spr:addEventListener("collide", enemy1.spr)
--enemy1.collision = onCollide
--enemy1:addEventListener("collision", enemy1)
