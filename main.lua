-- main.lua
-- first try

local physics = require("physics")
local sprite = require("sprite")

local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
Player = {x = 0, y = 0, spr = nil, disguised = false, isTouching = false, touchedObject = nil}

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
    
    local object = {x = x, y = y, spr = self.spr, diguised = self.disguised, isTouching = self.isTouching, touchedObject = self.touchedObject}
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

function Player:enterFrame(event)

	if(self.isTouching) then
		
		local l = enemyList
			while l do
			if(l.value.spr == self.touchedObject) then
				--print(l.value.orientation)
				if((l.value.orientation == 0 and l.value.spr.direction == 'r') or (l.value.orientation == 1 and l.value.spr.direction == 'u')) then
					background:setFillColor(255,0,0)
					--LOSE
				elseif((l.value.orientation == 0 and l.value.spr.direction == 'l') or (l.value.orientation == 1 and l.value.spr.direction == 'd')) then
					background:setFillColor(0,0,200)
				end
			elseif(l.value.physDot == self.touchedObject) then
				if((l.value.orientation == 0 and l.value.physDot.direction == 'l') or (l.value.orientation == 1 and l.value.physDot.direction == 'd')) then
					background:setFillColor(255,0,0)
				elseif((l.value.orientation == 0 and l.value.physDot.direction == 'r') or (l.value.orientation == 1 and l.value.physDot.direction == 'u')) then
					background:setFillColor(0,0,200)
				end
			end
			l = l.next
		end
		
		--[[l = cameraList
		while l do
			--print(l.value.spr)
			if(l.value.spr == self.touchedObject) then
				background:setFillColor(255,0,0)
			end
			l = l.next
		end]]
	end
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
Enemy = { x = 0, y = 0 , spr = nil, physDot = nil, initDirection = nil, bound1 = nil, bound2 = nil, orientation = nil, pathLength = 0}
function Enemy:new(x, y, orientation, pathLen)
	self.x = x; self.y = y; self.orientation = orientation; self.pathLength = pathLen


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
	
	print(self.orientation)
	print(self.orientation == 0)
	if(self.orientation == 0) then
		self.initDirection = 'r'
	else
		self.initDirection = 'u'
	end
	
	print(self.initDirection)
	
	self.spr = enemy
	self.physDot = display.newRect(self.x - 5 , self.y - 5, 10, 10)
	self.spr.direction = self.initDirection
	self.physDot.direction = self.initDirection
	
	
	
	local object = {x = x, y = y, spr = self.spr, physDot = self.physDot, direction = self.spr.direction, orientation = self.orientation, pathLength = self.pathLength}
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

function Enemy:init()
	physics.addBody(self.spr, self:getSprBody())
	physics.addBody(self.physDot, self:getPhysDotBody())
	--enemy1.spr.angularDamping = 2
	self:spawnBounds(self.pathLength)
	self.spr.collision = boundCollide
	self.spr:addEventListener("collision", self.spr)
	self.physDot.collision = boundCollide
	self.physDot:addEventListener("collision", self.physDot)
	--enemy1.physDot.isBodyActive = false
	self:patrol()
	enemyList = {next = enemyList, value = self}

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

cameraShape = {0,0 , 90, -40 , 90,40}
cameraBody = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = cameraShape}
pivotBody = {friction = 0.7, isSensor = true}

Camera = {x = 0, y = 0 , spr = nil, initDirection = 'r', pivot = nil, joint = nil, timerProc = false, rotation = 0}
function Camera:new(x, y, rotation)
	self.x = x; self.y = y; self.rotation = rotation
	
	--[[local cameraSheet = sprite.newSpriteSheet("ball_white.png", 72,72)
	local cameraSet = sprite.newSpriteSet(cameraSheet, 1, 1)
	sprite.add(cameraSet, "scan", 1, 1, 1000)
	
	local camera = sprite.newSprite(cameraSet)]]
	--self.spr = display.newImage("ball_white.png")
	self.spr = display.newRect(self.x, self.y - 5, 100, 10)
	self.spr.x = x
	self.spr.y = y
	--[[camera.x = x
	camera.y = y
	camera.xScale = 0.5
	camera.yScale = 0.5
    camera:prepare("scan")
    camera:play()]]
	
	--self.spr = camera
	
	self.spr.direction = self.initDirection
	self.pivot = display.newRect(self.x - 5 , self.y - 5, 10, 10)



	local object = {x = x, y = y, spr = self.spr, pivot = self.pivot, direction = self.spr.direction, joint = self.joint, timerProc = self.timerProc}
	setmetatable(object, {__index = Camera})
	self.spr.super = object
	
	return object
end

function Camera:setLocation(loc)
	self.spr.x = loc.x; self.spr.y = loc.y
	self.pivot.x = loc.x; self.pivot.y = loc.y
end

function Camera:getLocation()
	return {x = self.spr.x , y = self.spr.y}
end

function Camera:init()
	physics.addBody(self.spr, cameraBody)
	physics.addBody(self.pivot,  "static",  pivotBody)

	--camera.pivot.isFixedRotation = true
	local cameraJoint = physics.newJoint( "pivot",  self.pivot,self.spr,  self.x,self.y)
	cameraJoint.isMotorEnabled = true
	cameraJoint.motorSpeed = 60
	cameraJoint.isLimitEnabled = true
	cameraJoint.maxMotorTorque = 100000
	cameraJoint:setRotationLimits(-60 + self.rotation, 60 + self.rotation)

	self.joint = cameraJoint
	--camera1.spr.super.joint = cameraJoint


	Runtime:addEventListener("enterFrame", self)
	cameraList = {next = cameraList, value = self}
end

function Camera:enterFrame(event)
	--print(self.joint.jointAngle)
	lim1, lim2 = self.joint:getRotationLimits()
	--print(lim1 .. " and " .. lim2)
	if(self.joint.jointAngle <= lim1 or self.joint.jointAngle >= lim2) then
		if(not self.timerProc) then
			timer.performWithDelay(2000, self, 1)
			self.timerProc = true
		end
	elseif(self.joint.jointAngle >= lim1 and self.joint.jointAngle <= lim2) then
		self.timerProc = false
	end
end

function Camera:timer(event)
	self.joint.motorSpeed = self.joint.motorSpeed * -1
end


physics.start()
physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale(60)
physics.setGravity(0,0)
display.setStatusBar( display.HiddenStatusBar )

background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 200)

enemyList = nil
cameraList = nil



--local enemyBody = {density = 1.5, friction = 0.7, bounce = 0.3, radius = 50, isSensor = false}
local player = Player:new(250, 250)
physics.addBody(player.spr, playerBody)
player.spr.linearDamping = .8


local enemy1 = Enemy:new(150, 150, 0, 125)
enemy1:init()


local enemy2 = Enemy:new(350, 350, 1, 200)
enemy2:init()


--Rotation angles greater than 60 breaks the physics; negative angles seem to work ok
--Spawn Cameras with noticable change in initial angle bounds off the starting screen; they must snap to first bound before working normally
--[[local camera1 = Camera:new(350, 500, -180)
camera1:init()]]

local camera2 = Camera:new(350, 750, 60)
camera2:init()



local function onCollide(self, event)
	--[[if((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "began") then
		background:setFillColor(255,0,0)
		enemy1:applyForce(50, -50, enemy1.x, enemy1.y)
	elseif((event.object1 == enemy1 or event.object2 == enemy1) and (event.object1 == player or event.object2 == player) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end]]
	--[[if((((event.other == enemy1.spr) or (event.other == enemy2.spr)) or ((event.other == enemy1.physDot ) or (event.other == enemy2.physDot ))) and event.phase == "began") then
		background:setFillColor(255,0,0)
		--enemy2.spr:applyForce(50, -50, enemy1.spr.x, enemy2.spr.y)
	elseif((((event.other == enemy1.spr ) or (event.other == enemy2.spr)) or ((event.other == enemy1.physDot ) or (event.other == enemy2.physDot))) and event.phase == "ended") then
		background:setFillColor(0,0,200)
	end]]
	
	if(event.phase == "began") then
		
		local l = enemyList
		while l do
			if(l.value.spr == event.other) then
				self.super.isTouching = true
				self.super.touchedObject = event.other
				--print(l.value.orientation)
				if((l.value.orientation == 0 and l.value.spr.direction == 'r') or (l.value.orientation == 1 and l.value.spr.direction == 'u')) then
					background:setFillColor(255,0,0)
					--LOSE
				end
			elseif(l.value.physDot == event.other) then
				self.super.isTouching = true
				self.super.touchedObject = event.other
				if((l.value.orientation == 0 and l.value.physDot.direction == 'l') or (l.value.orientation == 1 and l.value.physDot.direction == 'd')) then
					background:setFillColor(255,0,0)
				end
			end
			l = l.next
		end
		
		l = cameraList
		while l do
			--print(l.value.spr)
			if(l.value.spr == event.other) then
				background:setFillColor(255,0,0)
			end
			l = l.next
		end
	elseif(event.phase == "ended") then
		local l = enemyList
		while l do
			if(l.value.spr == event.other) then
				self.super.isTouching = false
				self.super.touchedObject = nil
				if((l.value.orientation == 0 and l.value.spr.direction == 'r') or (l.value.orientation == 1 and l.value.spr.direction == 'u')) then
					background:setFillColor(0,0,200)
				end
			elseif(l.value.physDot == event.other) then
				self.super.isTouching = false
				self.super.touchedObject = nil
				if((l.value.orientation == 0 and l.value.physDot.direction == 'l') or (l.value.orientation == 1 and l.value.physDot.direction == 'd')) then
					background:setFillColor(0,0,200)
				end
			end
			l = l.next
		end
		
		l = cameraList
		while l do
			if(l.value.spr == event.other) then
				background:setFillColor(0,0,200)
			end
			l = l.next
		end 
	end
end


--[[local function onPostCollide(self, event)
	--enemy2.spr:setLinearVelocity(0,0)
	print("foot")
	--enemy2:setLocation({x = 350, y = 350})
	local l = enemyList
		while l do
			if(l.value.spr == event.other) then
				print(l.value.orientation)
				print(l.value.direction)
				if((l.value.orientation == 0 and l.value.spr.direction == 'r') or (l.value.orientation == 1 and l.value.spr.direction == 'u')) then
					background:setFillColor(255,0,0)
					--LOSE
				elseif((l.value.orientation == 0 and l.value.spr.direction == 'l') or (l.value.orientation == 1 and l.value.spr.direction == 'd')) then
					background:setFillColor(0,0,200)
				end
			elseif(l.value.physDot == event.other) then
				if((l.value.orientation == 0 and l.value.physDot.direction == 'l') or (l.value.orientation == 1 and l.value.physDot.direction == 'd')) then
					background:setFillColor(255,0,0)
				elseif((l.value.orientation == 0 and l.value.physDot.direction == 'r') or (l.value.orientation == 1 and l.value.physDot.direction == 'u')) then
					background.setFillColor(0,0,200)
				end
			end
			l = l.next
		end
		
		l = cameraList
		while l do
			--print(l.value.spr)
			if(l.value.spr == event.other) then
				background:setFillColor(255,0,0)
			end
			l = l.next
		end
	elseif(event.phase == "ended") then
		local l = enemyList
		while l do
			if(l.value.spr == event.other) then
				if((l.value.orientation == 0 and l.value.spr.direction == 'r') or (l.value.orientation == 1 and l.value.spr.direction == 'u')) then
					background:setFillColor(0,0,200)
				end
			elseif(l.value.physDot == event.other) then
				if((l.value.orientation == 0 and l.value.physDot.direction == 'l') or (l.value.orientation == 1 and l.value.physDot.direction == 'd')) then
					background:setFillColor(0,0,200)
				end
			end
			l = l.next
		end
		
		l = cameraList
		while l do
			if(l.value.spr == event.other) then
				background:setFillColor(0,0,200)
			end
			l = l.next
		end
end]]

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

Runtime:addEventListener("enterFrame", player)
--Runtime:addEventListener("collision", player.spr)
--player.spr.postCollision = onPostCollide
--player.spr:addEventListener("postCollision", player.spr)
--enemy1.spr.collide = boundCollide
	--print(boundCollide)
--enemy1.spr:addEventListener("collide", enemy1.spr)
--enemy1.collision = onCollide
--enemy1:addEventListener("collision", enemy1)
