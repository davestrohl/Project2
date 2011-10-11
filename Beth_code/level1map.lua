module(..., package.seeall)

--External Modules
sprite = require("sprite")
physics = require("physics")
menu = require("disguiseMenu")
local physicsData = (require "shapedefs").physicsData()
local playerphysics = (require "playershape").physicsData()

physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector

------------------------------------------------------------
--Globals - to be accessed from main.lua
callUnload = false
disguise="down"
guardsLeft = 5
--------------------------------------------------------------------




---------------------------------------------------------------------



-----------------------------------------------------------------
-----------------------------------------------------------------
--  Player
-----------------------------------------------------------------
-----------------------------------------------------------------
local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
Player = {x = 0, y = 0, spr = nil, disguised = false}

function Player:new(x, y)
    self.x = x; self.y = y
    local playerSheet = sprite.newSpriteSheet("../gfx/player_sheet.png", 64, 94.5)
    local playerSet = sprite.newSpriteSet(playerSheet, 1, 24)
    --Set up animations for all the costumes
    sprite.add(playerSet, "down", 1, 6, 1000)
    sprite.add(playerSet, "up", 7, 6, 1000)
    sprite.add(playerSet, "right", 13, 6, 1000)
    sprite.add(playerSet, "left", 19, 6, 1000)
    --sprite.add(playerSet, "dino", 6, 6, 5000)
    
    player = sprite.newSprite(playerSet)
    player.x = x
    player.y = y
    
    player:prepare("down")
    player:play()
    
    self.spr = player
    
    local object = {x = x, y = y, spr = self.spr}
    setmetatable(object, {__index = Player})
    self.spr.super = object
    return object
    
end

function Player:pose()
    -- print("posing")
    -- print(disguise)
    if disguise ~= "guard" or (disguise == "guard" and guardsLeft ~= 0) then
        if disguise == "guard" then
            guardsLeft = guardsLeft - 1
        end
        self.spr:prepare(disguise)
        self.spr:play()
    end
    --self.disguised = true
end

-- function Player:unpose()
    -- if self.disguised then
        -- self.spr:prepare("def")
        -- self.spr:play()
        -- self.disguised = false
    -- end
-- end

function Player:getLocation()
	return {x = self.spr.x , y = self.spr.y}
end
	
function Player:setLocation( loc )
	self.spr.x = loc.x; self.spr.y = loc.y
end


local function playerTouch(self, event)
    local t = event.target
    if event.phase == "began" then
        display.getCurrentStage():setFocus(t)
        t.isFocus = true
        t:setLinearVelocity(0,0)
        line = nil
    elseif t.isFocus then
        if event.phase == "moved" then
            if ( line ) then
				line.parent:remove( line ) -- erase previous line, if any
			end
			line = display.newLine( event.xStart, event.yStart, event.x,event.y )
			line:setColor( 255, 255, 255, 50 )
			line.width = 15
        elseif (event.phase == "ended" or event.phase == "cancelled") then
            display.getCurrentStage():setFocus(nil)
            t.isFocus = false
            if ( line ) then
				line.parent:remove( line )
			end
            if disguise ~= "guard" and disguise ~= "up" then
            -- t is the player's sprite, so t:pose() can't be used
                disguise = "up"
                t:prepare(disguise)
                t:play()
            end
            dx = event.x - event.xStart
            dy = event.y - event.yStart
            hp = (dx^2 + dy^2)^.5
            print(dx .. " and " .. dy)
            if dy ~= 0 and dx <= -dy and -dx <= -dy then   --up
                disguise = "up"
                t:prepare(disguise)
                t:play()
            elseif dx ~= 0 and dy < -dx and -dy < -dx then --left
                disguise = "left"
                t:prepare(disguise)
                t:play()
            elseif dy ~= 0 and dx <= dy and -dx <= dy then --down
                disguise = "down"
                t:prepare(disguise)
                t:play()
            else
                disguise = "right"
                t:prepare(disguise)
                t:play()
            end
            if hp ~= 0 then
                t:applyForce( 300*(dx/hp), 300*(dy/hp), t.x, t.y )
            end
        end
    end
end

--end player
-----------------------------------------------------------------------
-----------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------    Enemy
-----------------------------------------------------------------------
-----------------------------------------------------------------------
viewRight = {0,0 , 80,-30 , 80,30}
viewLeft = {0,0 , -80,30 , -80,-30}
local enemyBodyLeft = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewLeft}
local enemyBodyRight = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewRight}
Enemy = { x = 0, y = 0 , spr = nil, initDirection = 'r', bound1 = nil, bound2 = nil}
function Enemy:new(x, y)
	self.x = x; self.y = y

	
	local enemySheet = sprite.newSpriteSheet("../gfx/test_whitetile.png", 72,72)
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
					--self:applyAngularImpulse(10)	
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
--end enemy
-----------------------------------------------------------------------
-----------------------------------------------------------------------


-----------------------------------------------------------------------
-----------------------------Camera-------------------------------
viewRight = {0,0 , 80,-30 , 80,30}
local cameraBody = {density = 1.5, friction = 0.7, bounce = 0.3, isSensor = true, shape = viewRight}
Camera = { x = 0, y = 0, spr = nil, initDirection = 'u'}
function Camera:new(x, y)
    self.x = x; self.y = y
    
    local cameraSheet = sprite.newSpriteSheet("../gfx/test_whitetile.png", 72, 72)
    local cameraSet = sprite.newSpriteSet(enemySheet, 1, 1)
    sprite.add(cameraSet, "spin", 1, 1, 5000)
    
    local camera = sprite.newSprit(enemySet)
    camera.x = x
    camera.y = y
    camera.xScale = 0.5
    camera.yScale = 0.5
    camera:prepare("patrol")
    camera:play()
    
    self.spr = camera
    self.spr.direction = self.initdirection
    
    local object = {x = x, y = y, spr = self.spr, direction = self.spr.direction}
    setmetatable(object, {__index = Camera})
    self.spr.super = object
    
    return object
end

function Camera:getLocation()
	return {x = self.spr.x , y = self.spr.y}
end
	
function Camera:setLocation( loc )
	self.spr.x = loc.x; self.spr.y = loc.y
end

function Camera:rotate()
    
end
--end camera
----------------------------------------------------------------------
----------------------------------------------------------------------

--
-----------------------------------------------------------------------
--  Level Over function
local levelOver = function()
    Runtime: addEventListener("enterFrame", gameListener)
    --next_level = "level2map"
    print(next_level)
    callUnload = true
end
-----------------------------------------------------------------------
--


--
-----------------------------------------------------------------------
--  levelLoop() this level's enterFrame event
local levelLoop = function (event)
    --levelOver()
    --[[
    This is your game's main enterFrame event listener.
    This function is called on every frame.

    Think of this kind of like a main() loop.

    ]]--
    --print(disguise)
    --player:pose()

end


--
----------------------------------------------------------------------
-- functions used in init
--split function to be used in init
split=function(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
----------------------------------------------------------------------
--------------------------------------------------------------------
--map read in function

mapinit=function()
--map initialization
    --read in from file
    local path = system.pathForFile("level1.txt", system.ResourceDirectory)
    --print(path)
    local fh= io.open(path, "r") -- io.open opens a file at path - returns nil if no file found
    if fh then
        while true do
            local line = fh:read()
            if line == nil then break end
            line = split(line, " ")
            file = line[1]
            if file == "enemy" then
                --print("enemy")
                x = line[2]
                y = line[3]
                bx = line[4]
                by = line[5]
                --image == "../gfx/test_redtile.png"
                --bodyname = "test_redtile"
                local obj = Enemy:new(x, y)
                local loc = obj:getLocation()
                physics.addBody(obj.spr, enemyBodyRight)
                obj.spr.angularDamping = 2
                obj:spawnBounds({x = bx, y = by})
                obj.spr.collision = boundCollide
                obj.spr:addEventListener("collision", obj.spr)
                obj:patrol()
                worldgroup:insert(obj.spr)
                worldgroup:insert(obj.spr.bound1)
                worldgroup:insert(obj.spr.bound2)
            else
                --print("not enemy")
                x = line[2]
                y = line[3]
                width=line[4]
                height=line[5]
                if file == "desk" then
                    image="../gfx/desk.png"
                    bodyname="desk"
                elseif file == "plant" then
                    image ="../gfx/plant.png"
                    bodyname="plant"
                else
                    image = nil
                end
                local objSheet = sprite.newSpriteSheet(image, width, height)
                local objSet = sprite.newSpriteSet(objSheet,1,1)
                sprite.add(objSet, "def", 1, 1, 1000)
                local obj = sprite.newSprite(objSet)
                obj.x = x
                obj.y = y
                obj.xScale = 1
                obj.yScale = 1
                physics.addBody(obj, "static", physicsData:get(bodyname))
                worldgroup:insert(obj)
            end
            
        end
    else
        print("fail")
    end
end
--end map init
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- Level 1 initialize function
----------------------------------------------------------------------
----------------------------------------------------------------------

init=function()
    --make world group for dragging the world around
    worldgroup=display.newGroup()
    --put big rectangle in world group for touch purposes
    --world = display.newRect(0,0,1056,960)
    --world:setFillColor(128,0,0)
    world= display.newImage("../gfx/floor.png")
    worldgroup:insert(world)

    --UI button listeners
    bottomListener = function(event)
        --print("bottom hit")
        --levelOver()
        worldgroup:setReferencePoint(display.BottomCenterReferencePoint)
        if worldgroup.y>200 then
            worldgroup:translate(0,-100)
        end
        worldgroup:setReferencePoint(display.CenterReferencePoint)
    end
    topListener = function(event)
        worldgroup:setReferencePoint(display.TopCenterReferencePoint)
        if worldgroup.y<654 then
            worldgroup:translate(0,100)
        end
        worldgroup:setReferencePoint(display.CenterReferencePoint)
    end
    leftListener = function(event)
        worldgroup:setReferencePoint(display.CenterLeftReferencePoint)
        if worldgroup.x<280 then
            worldgroup:translate(100,0)
        end
        worldgroup:setReferencePoint(display.CenterReferencePoint)
    end
    rightListener = function(event)
        worldgroup:setReferencePoint(display.CenterRightReferencePoint)
        if worldgroup.x >200 then
            worldgroup:translate(-100,0)
        end
        worldgroup:setReferencePoint(display.CenterReferencePoint)
    end

    physics.start()
    --physics.setDrawMode("hybrid")
	physics.setGravity( 0, 0 )
    --print("hi")
    disguise="def"
    --put invisible walls around the world
    top = display.newRect(0,0, 1056, 0)
    physics.addBody(top, "static", {bounce =0})
    worldgroup:insert(top)
    bottom = display.newRect(0,960,1056,0)
    physics.addBody(bottom, "static", {bounce =0})
    worldgroup:insert(bottom)
    left = display.newRect(0,0,0,960)
    physics.addBody(left, "static", {bounce =0})
    worldgroup:insert(left)
    right = display.newRect(1056,0,0,960)
    physics.addBody(right, "static", {bounce =0})
    worldgroup:insert(right)
    

	
	player = Player:new(250, 250)
	physics.addBody(player.spr, playerphysics:get("player_sheet"))
	player.spr.linearDamping = .8
    player.spr.isFixedRotation = true


	-- local enemy1 = Enemy:new(150, 150)
	-- local loc = enemy1:getLocation()
	-- physics.addBody(enemy1.spr, enemyBodyRight)
	-- enemy1.spr.angularDamping = 2
	-- enemy1:spawnBounds({x = 125, y = 0})
	-- enemy1.spr.collision = boundCollide
	-- enemy1.spr:addEventListener("collision", enemy1.spr)
	-- enemy1:patrol()


	-- local enemy2 = Enemy:new(350, 350)
	-- physics.addBody(enemy2.spr, enemyBodyRight)
	-- enemy2.spr.angularDamping = 1
	-- enemy2:spawnBounds({x = 100, y = 0})
	-- enemy2.spr.collision = boundCollide
	-- enemy2.spr:addEventListener("collision", enemy2.spr)
	-- enemy2:patrol()
	

	-- worldgroup:insert(enemy1.spr)
	-- worldgroup:insert(enemy1.spr.bound1)
	-- worldgroup:insert(enemy1.spr.bound2)
	-- worldgroup:insert(enemy2.spr)
	-- worldgroup:insert(enemy2.spr.bound1)
	-- worldgroup:insert(enemy2.spr.bound2)
	
    --call map init
    mapinit()
	worldgroup:insert(player.spr)
-- OLD worldgroup's touch event function
-- local moveWorld = function(event)
    -- px = player.spr.x
    -- py = player.spr.y
    -- dist= math.sqrt((px-event.xStart)^2 + (py - event.yStart)^2)
    -- if dist > 200 then
        -- if event.phase == "ended" then
            -- delta_x = event.x - event.xStart
            -- delta_y = event.y - event.yStart
            -- worldgroup:translate(delta_x, delta_y)
        -- end
    -- end
-- end

    -- STOP main.lua's event listener (to free up processing power)
    Runtime:removeEventListener( "enterFrame", gameListener )

    -- START EVENT LISTENERS

    -- the screen's main enterFrame event
    Runtime:addEventListener( "enterFrame", levelLoop )
    player.spr.touch = playerTouch
	player.spr:addEventListener("touch", player.spr)
    
	
	--Runtime:addEventListener("collision", onCollide)
	player.spr.collision = onCollide
	player.spr:addEventListener("collision", player.spr)
	player.spr.postCollision = onPostCollide
	player.spr:addEventListener("postCollision", player.spr)
    -- OLD worldgroup touch eventlistener
    --worldgroup:addEventListener("touch", moveWorld)
    top_button:addEventListener("touch", topListener)
    top_button:toFront()
    bottom_button:addEventListener("touch", bottomListener)
    bottom_button:toFront()
    right_button:addEventListener("touch", rightListener)
    right_button:toFront()
    left_button:addEventListener("touch", leftListener)
    left_button:toFront()
    Runtime:addEventListener("accelerometer", onShake)
    open_menu = true
end
--end initialize
----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
------------------------Shake Listener------------------------
----------------------------------------------------------------------
function onShake()
    --print("SHAKE")
    --pause everything
    Runtime:removeEventListener( "enterFrame", levelLoop )
    physics:pause()
    if open_menu then
        open_menu=false
        menu:init()
        
    else
        open_menu=true
        menu:push()
    end
    --player:pose()
    --resume everything
    --print(disguise)
    Runtime:addEventListener( "enterFrame", levelLoop )
    physics:start()
end
-----------------------------------------------------------------------
--



---------------------------------------------------------------------
---------------------------------------------------------------------
--  Unload me function for when the level is over
---------------------------------------------------------------------
---------------------------------------------------------------------
unloadMe = function()
--clears everything at end of level
    -- remove any event listeners
    Runtime:removeEventListener( "enterFrame", levelLoop )
    top_button:removeEventListener("touch", topListener)
    bottom_button:removeEventListener("touch", bottomListener)
    right_button:removeEventListener("touch", rightListener)
    left_button:removeEventListener("touch", leftListener)
    --Runtime:removeEventListener("accelerometer", onShake)

    -- also, don't forget to stop any timers that you created
    -- example:
    -- timer.cancel( myTimer )


    --remove groups and objects
    worldgroup:removeSelf()
    physics:stop()

    -- collect any/all garbage
    collectgarbage( "collect" )
    return "level2map"
    end
--end unloadme
-----------------------------------------------------------------------
-----------------------------------------------------------------------