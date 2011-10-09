-- main.lua
-- first try

local physics = require("physics")
local sprite = require("sprite")





local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
Player = {x = 0, y = 0, spr = nil, disguised = false}

function Player:new(x, y)
    self.x = x; self.y = y
    
    local playerSheet = sprite.newSpriteSheet("gfx/mock.png", 72, 72)
    local playerSet = sprite.newSpriteSet(playerSheet, 1, 25)
    --Set up animations for all the costumes
    sprite.add(playerSet, "def", 1, 5, 5000)
    sprite.add(playerSet, "plant", 21, 5, 5000, -2)
    sprite.add(playerSet, "security", 11, 5, 5000)
    sprite.add(playerSet, "statue", 16, 5, 5000)
    sprite.add(playerSet, "change", 6, 5, 1000, 1)
    
    local player = sprite.newSprite(playerSet)
    player.x = x
    player.y = y
    
    player:prepare("def")
    player:play()
    
    self.spr = player
    
    local object = {x = x, y = y, spr = self.spr}
    setmetatable(object, {__index = Player})
    self.spr.super = object
    return object
    
end

function Player:pose(disguise)
    self.spr:prepare(disguise)
    self.spr:play()
    self.disguised = true
end

function Player:unpose()
    self.spr:prepare("def")
    self.spr:play()
    self.disguised = false
end

function Player:getLocation()
	return {x = self.spr.x , y = self.spr.y}
end
	
function Player:setLocation( loc )
	self.spr.x = loc.x; self.spr.y = loc.y
end

viewRight = {0,0 , 80,-30 , 80,30}
viewLeft = {0,0 , -80,30 , -80,-30}
viewUp = {0,0 , -30,-80 , 30,-80}
viewDown = {0,0 , 30,80 , -30,80}
--LEFT = PHYSDOT
--RIGHT = SPR
enemyBodyLeft = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewLeft}
enemyBodyRight = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewRight}
enemyBodyUp = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewUp}
enemyBodyDown = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewDown}
Enemy = { x = 0, y = 0 , spr = nil, physDot = nil, initDirection = nil, bound1 = nil, bound2 = nil, orientation = nil}
function Enemy:new(x, y, orientation)
	self.x = x; self.y = y; self.orientation = orientation

	
	
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
	
	if(self.orientation == 0) then
		self.initDirection = 'r'
	else
		self.initDirection = 'u'
	end
	
	self.spr = enemy
	self.physDot = display.newRect(self.x - 5 , self.y - 5, 10, 10)
	self.spr.direction = self.initDirection
	self.physDot.direction = self.initDirection
	
	
	
	local object = {x = x, y = y, spr = self.spr, physDot = self.physDot, direction = self.spr.direction}
	setmetatable(object, {__index = Enemy})
	self.spr.super = object
	self.physDot.super = object
	
	return object
end

local function boundCollide(self, event)

	if ((event.other == self.bound1 or event.other == self.bound2) and event.phase == "began") then
					--print(self.super)
					if(self.direction == 'l') then
						self.direction = 'r'
						self.super.spr.direction = 'r'
						self.super.physDot.direction = 'r'
					elseif(self.direction == 'r') then
						self.direction = 'l'
						self.super.spr.direction = 'l'
						self.super.physDot.direction = 'l'
					elseif(self.direction == 'u') then
						self.direction = 'd'
						self.super.spr.direction = 'd'
						self.super.physDot.direction = 'd'
					elseif(self.direction == 'd') then
						self.direction = 'u'
						self.super.spr.direction = 'u'
						self.super.physDot.direction = 'u'
					end
					--print(self.super.spr.direction)
					self.super:patrol()
				elseif ((event.other == self.bound1 or event.other == self.bound2) and event.phase == "ended") then
					--self:applyAngularImpulse(10)	
				end
end

function Enemy:spawnBounds( dist )

	if(self.orientation == 0) then
		local bound1 = display.newRect(self.spr.x - dist, self.spr.y, 10, 10)
		physics.addBody(bound1, "static", {bounce = 0.2, isSensor = true})
		self.spr.bound1 = bound1
		self.physDot.bound1 = bound1
		local bound2 = display.newRect(self.spr.x + dist, self.spr.y, 10, 10)
		physics.addBody(bound2, "static", {bounce = 0.2, isSensor = true})
		self.spr.bound2 = bound2
		self.physDot.bound2 = bound2
	else
		local bound1 = display.newRect(self.spr.x, self.spr.y - dist, 10, 10)
		physics.addBody(bound1, "static", {bounce = 0.2, isSensor = true})
		self.spr.bound1 = bound1
		self.physDot.bound1 = bound1
		local bound2 = display.newRect(self.spr.x, self.spr.y + dist, 10, 10)
		physics.addBody(bound2, "static", {bounce = 0.2, isSensor = true})
		self.spr.bound2 = bound2
		self.physDot.bound2 = bound2
	end
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
	self.physDot.x = loc.x; self.physDot.y =loc.y
end

function Enemy:getSprBody()
	if(self.orientation == 0) then
		return enemyBodyRight
	else
		return enemyBodyUp
	end
end

function Enemy:getPhysDotBody()
	if(self.orientation == 0) then
		return enemyBodyLeft
	else
		return enemyBodyDown
	end
end

--function Enemy:get

function Enemy:patrol()

	if(self.spr.direction == 'l') then
		
		--self.physDot.collision = boundCollide
		--self.physDot:addEventListener("collision", self.physDot)
		--self.spr:removeEventListener("collision", self.spr)
		--self.spr.isBodyActive = false
		--self.physDot.isBodyActive = true
		--[[player:removeEventListener("collision", player)
		player.collision = onCollisionLeft
		player:addEventListener("collision", player)]]
		self.spr:setLinearVelocity(-30, 0)
		self.physDot:setLinearVelocity(-30, 0)

		--self.spr:applyLinearImpulse(math.random(-500, 500), math.random(-500, 500), self.spr.x + math.random(-20, 20), self.spr.y + math.random(-20, 20))
	elseif(self.spr.direction == 'r') then
		--self.spr.collision = boundCollide
		--self.spr:addEventListener("collision", self.spr)
		--self.physDot:removeEventListener("collision", self.physDot)
		--self.spr.isBodyActive = true
		--self.physDot.isBodyActive = false
		--[[player:removeEventListener("collision", player)
		player.collision = onCollideRight
		player:addEventListener("collision", player)]]
		
		self.spr:setLinearVelocity(30, 0)
		self.physDot:setLinearVelocity(30, 0)
		
	elseif(self.spr.direction == 'u') then
		self.spr:setLinearVelocity(0, -30)
		self.physDot:setLinearVelocity(0, -30)
		
	elseif(self.spr.direction == 'd') then

		self.spr:setLinearVelocity(0, 30)
		self.physDot:setLinearVelocity(0, 30)
		

	end
end

cameraShape = {0,0 , 90, 40 , 90,-40}
cameraBody = {density = 2.0, friction = 0.5, bounce = 0.3, isSensor = false, shape = cameraShape}
--cameraBody = {density = 0.8, friction = 0.3, bounce = 0.3}
pivotBody = {friction = 0.7, isSensor = false}

Camera = {x = 0, y = 0 , spr = nil, initDirection = 'r', pivot = nil}
function Camera:new(x, y)
	self.x = x; self.y = y
	
	--[[local cameraSheet = sprite.newSpriteSheet("ball_white.png", 72,72)
	local cameraSet = sprite.newSpriteSet(cameraSheet, 1, 1)
	sprite.add(cameraSet, "scan", 1, 1, 1000)
	
	local camera = sprite.newSprite(cameraSet)]]
	local camera = display.newImage("ball_white.png")
	camera.x = x
	camera.y = y
	camera.xScale = 0.5
	camera.yScale = 0.5
    --camera:prepare("scan")
    --camera:play()
	
	self.spr = camera
	self.spr.direction = self.initDirection
	self.pivot = display.newRect(self.x - 10 , self.y - 5, 100, 100)
	--self.pivot = display.newImage("ball_white.png")
	--self.pivot.x = x
	--self.pivot.y = y


	local object = {x = x, y = y, spr = self.spr, pivot = self.pivot, direction = self.spr.direction}
	setmetatable(object, {__index = Enemy})
	self.spr.super = object
	
	return object
end

--function Camera:scan()
	
	
--[[function Enemy:changeDirections()
	if(self.direction == 'l') then
		self.direction = 'r'
	else
		self.direction = 'l'
	end
end	]]
		

physics.start()
physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale(60)
--physics.setGravity(0,0)
display.setStatusBar( display.HiddenStatusBar )

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 200)

--local enemyBody = {density = 1.5, friction = 0.7, bounce = 0.3, radius = 50, isSensor = false}
local player = Player:new(250, 250)
physics.addBody(player.spr, playerBody)
player.spr.linearDamping = .8


local enemy1 = Enemy:new(150, 150, 0)
local loc = enemy1:getLocation()
physics.addBody(enemy1.spr, enemy1:getSprBody())
physics.addBody(enemy1.physDot, enemy1:getPhysDotBody())
enemy1.spr.angularDamping = 2
enemy1:spawnBounds(125)
enemy1.spr.collision = boundCollide
enemy1.spr:addEventListener("collision", enemy1.spr)
enemy1.physDot.collision = boundCollide
enemy1.physDot:addEventListener("collision", enemy1.physDot)
--enemy1.physDot.isBodyActive = false
enemy1:patrol()


local enemy2 = Enemy:new(350, 350, 1)
physics.addBody(enemy2.spr, enemy2:getSprBody())
physics.addBody(enemy2.physDot, enemy2:getPhysDotBody())
enemy2.spr.angularDamping = 1
enemy2:spawnBounds(100)
enemy2.spr.collision = boundCollide
enemy2.spr:addEventListener("collision", enemy2.spr)
enemy2.physDot.collision = boundCollide
enemy2.physDot:addEventListener("collision", enemy2.physDot)
--enemy2.physDot.isBodyActive = false
enemy2:patrol()

local camera = Camera:new(350, 500)
physics.addBody(camera.spr, "static", cameraBody)
physics.addBody(camera.pivot,  pivotBody)


--camera.pivot.isFixedRotation = true
cameraJoint = physics.newJoint( "pivot", camera.pivot, camera.spr, camera.x,camera.y)
--[[cameraJoint.isMotorEnabled = true
cameraJoint.motorSpeed = 100
cameraJoint.isLimitEnabled = true
cameraJoint.maxMotorTorque = 100000
cameraJoint:setRotationLimits(-45, 90)]]
--camera.spr:applyLinearImpulse(0, 45, camera.spr.x + 10, camera.spr.y)


local function onCollide(self, event)
	--[[if((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "began") then
		background:setFillColor(255,0,0)
		enemy1:applyForce(50, -50, enemy1.x, enemy1.y)
	elseif((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end]]
	if(((event.other == enemy1.spr)or (event.other == enemy2.spr)) or ((event.other == enemy1.physDot ) or (event.other == enemy2.physDot )) and event.phase == "began") then
		--if(
		background:setFillColor(255,0,0)
		--enemy2.spr:applyForce(50, -50, enemy1.spr.x, enemy2.spr.y)
	elseif(((event.other == enemy1.spr ) or (event.other == enemy2.spr )) or ((event.other == enemy1.physDot ) or (event.other == enemy2.physDot)) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end
	--[[if((event.other == enemy1.physDot or event.other == enemy2.physDot) and event.phase == "began") then
		--if(
		background:setFillColor(255,0,0)
		--enemy2.spr:applyForce(50, -50, enemy1.spr.x, enemy2.spr.y)
	elseif((event.other == enemy1.physDot or event.other == enemy2.physDot) and event.phase == "ended") then
		background:setFillColor(0,0,200)
    end]]
	
end


local function onPostCollide(self, event)
	--enemy2.spr:setLinearVelocity(0,0)
	--enemy2:setLocation({x = 350, y = 350})
end

local function playerTouch(self, event)
    -- print(event.target)
    -- print(player.spr)
    local t = event.target
    if event.phase == "began" then
        display.getCurrentStage():setFocus(t)
        t.isFocus = true
        line = nil
    elseif t.isFocus then
        if event.phase == "moved" then
            if ( line ) then
				line.parent:remove( line ) -- erase previous line, if any
			end
			line = display.newLine( t.x,t.y, event.x,event.y )
			line:setColor( 255, 255, 255, 50 )
			line.width = 15
        elseif (event.phase == "ended" or event.phase == "cancelled") then
            display.getCurrentStage():setFocus(nil)
            t.isFocus = false
            if ( line ) then
				line.parent:remove( line )
			end
            t:applyForce( (event.x - t.x), (event.y - t.y), t.x, t.y )	
        end
    end
end

player.spr.touch = playerTouch
player.spr:addEventListener("touch", player.spr)
--Runtime:addEventListener("collision", onCollide)
player.spr.collision = onCollide
player.spr:addEventListener("collision", player.spr)
player.spr.postCollision = onPostCollide
player.spr:addEventListener("postCollision", player.spr)
--enemy1.spr.collide = boundCollide
	--print(boundCollide)
--enemy1.spr:addEventListener("collide", enemy1.spr)
--enemy1.collision = onCollide
--enemy1:addEventListener("collision", enemy1)
