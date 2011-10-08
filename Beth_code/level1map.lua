module(..., package.seeall)

--External Modules
sprite = require("sprite")
physics = require("physics")

physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector

--------------------------------------------------------------------
--make world group for dragging the world around
worldgroup=display.newGroup()
--put big rectangle in world group for touch purposes
local world = display.newRect(0,0,1056,960)
world:setFillColor(128,0,0)
worldgroup:insert(world)

--UI button listeners
bottomListener = function(event)
    worldgroup:translate(0,-100)
end
topListener = function(event)
    worldgroup:translate(0,100)
end
leftListener = function(event)
    worldgroup:translate(100,0)
end
rightListener = function(event)
    worldgroup:translate(-100,0)
end



---------------------------------------------------------------------

--Globals - to be accessed from main.lua
callUnload = false

-----------------------------------------------------------------
-----------------------------------------------------------------
--  Player
-----------------------------------------------------------------
-----------------------------------------------------------------
local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
Player = {x = 0, y = 0, spr = nil, disguised = false}

function Player:new(x, y)
    self.x = x; self.y = y
    
    local playerSheet = sprite.newSpriteSheet("../gfx/mock.png", 72, 72)
    local playerSet = sprite.newSpriteSet(playerSheet, 1, 25)
    --Set up animations for all the costumes
    sprite.add(playerSet, "def", 1, 5, 5000)
    sprite.add(playerSet, "plant", 21, 5, 5000, -2)
    sprite.add(playerSet, "security", 11, 5, 5000)
    sprite.add(playerSet, "statue", 16, 5, 5000)
    sprite.add(playerSet, "change", 6, 5, 1000, 1)
    
    player = sprite.newSprite(playerSet)
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


local function playerTouch(self, event)
    -- print(event.target)
    -- print(player.spr)
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
			line = display.newLine( t.x,t.y, event.x,event.y )
			line:setColor( 255, 255, 255, 50 )
			line.width = 15
            worldgroup:insert(line)
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
local levelOver = function(n_lvl)
    Runtime: addEventListener("enterFrame", gameListener)
    next_level = n_lvl -- next_level is a global from main.lua
    callUnload = true
end
-----------------------------------------------------------------------
--


--
-----------------------------------------------------------------------
--  levelLoop() this level's enterFrame event
local levelLoop = function (event)
    --[[

    This is your game's main enterFrame event listener.
    This function is called on every frame.

    Think of this kind of like a main() loop.

    ]]--

end
-----------------------------------------------------------------------
--

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


-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- Level 1 initialize function
----------------------------------------------------------------------
----------------------------------------------------------------------


init=function()
    physics.start()
    physics.setDrawMode("hybrid")
	physics.setGravity( 0, 0 )

    --put invisible walls around the world
    top = display.newRect(0,0, 1056, 0)
    physics.addBody(top, "static", {bounce =1})
    worldgroup:insert(top)
    bottom = display.newRect(0,960,1056,0)
    physics.addBody(bottom, "static", {bounce =1})
    worldgroup:insert(bottom)
    left = display.newRect(0,0,0,960)
    physics.addBody(left, "static", {bounce =1})
    worldgroup:insert(left)
    right = display.newRect(1056,0,0,960)
    physics.addBody(right, "static", {bounce =1})
    worldgroup:insert(right)
    

	
	local player = Player:new(250, 250)
	physics.addBody(player.spr, playerBody)
	player.spr.linearDamping = .8
    player.spr.isFixedRotation = true


	local enemy1 = Enemy:new(150, 150)
	local loc = enemy1:getLocation()
	physics.addBody(enemy1.spr, enemyBodyRight)
	enemy1.spr.angularDamping = 2
	enemy1:spawnBounds({x = 125, y = 0})
	enemy1.spr.collision = boundCollide
	enemy1.spr:addEventListener("collision", enemy1.spr)
	enemy1:patrol()


	local enemy2 = Enemy:new(350, 350)
	physics.addBody(enemy2.spr, enemyBodyRight)
	enemy2.spr.angularDamping = 1
	enemy2:spawnBounds({x = 100, y = 0})
	enemy2.spr.collision = boundCollide
	enemy2.spr:addEventListener("collision", enemy2.spr)
	enemy2:patrol()
	
	worldgroup:insert(player.spr)
	worldgroup:insert(enemy1.spr)
	worldgroup:insert(enemy1.spr.bound1)
	worldgroup:insert(enemy1.spr.bound2)
	worldgroup:insert(enemy2.spr)
	worldgroup:insert(enemy2.spr.bound1)
	worldgroup:insert(enemy2.spr.bound2)
	
    --map initialization
    --read in from file
    local path = system.pathForFile("test.txt", system.ResourceDirectory)
    --print(path)
    local fh= io.open(path, "r") -- io.open opens a file at path - returns nil if no file found
    if fh then
        while true do
            local line = fh:read()
            if line == nil then break end
            line = split(line, " ")
            file = line[1]
            x = line[2]
            y = line[3]
            width=line[4]
            height=line[5]
            --print(v)
            local objSheet = sprite.newSpriteSheet(file, width, height)
            local objSet = sprite.newSpriteSet(objSheet,1,1)
            sprite.add(objSet, "def", 1, 1, 1000)
            local obj = sprite.newSprite(objSet)
            obj.x = x
            obj.y = y
            obj.xScale = 1
            obj.yScale = 1
            physics.addBody(obj, "static", {bounce =1})
            worldgroup:insert(obj)
        end
    else
        print("fail")
    end
    
---------------------------------------------------------------------
--Initial worldgroup's touch event function
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
--
----------------------------------------------------------------------
    --local objSheet = sprite.newSpriteSheet("gfx/floor_tile.jpg", 72, 72)
    -- local objSet = sprite.newSpriteSet(objSheet, 1, 1)
    -- sprite.add(objSet, "def", 1, 1, 1000)
    -- local obj = sprite.newSprite(objSet)
    -- obj.x = display.contentWidth / 3
    -- obj.y = display.contentHeight / 3
    -- obj.xScale = 0.5
    -- obj.yScale = 0.5
    -- call all of your creation functions
    -- here, and start any event listeners.

    -- call reset function (to reset screen variables such as score)
    -- example:
    -- resetScreenSettings()

    -- call creation functions:

    -- examples:
    -- drawScreenObjects()
    -- createGameMenuWindow()

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
    bottom_button:addEventListener("touch", bottomListener)
    right_button:addEventListener("touch", rightListener)
    left_button:addEventListener("touch", leftListener)
end
--end initialize
----------------------------------------------------------------------
----------------------------------------------------------------------



---------------------------------------------------------------------
---------------------------------------------------------------------
--  Unload me function for when the level is over
---------------------------------------------------------------------
---------------------------------------------------------------------
unloadMe = function()

    --[[

    This is what is called when the screen is unloaded.

    For example, you probably want to unload this screen when the
    obj has a game over. So when a game over is detected (gameLives == 0),
    all you need to do is set these two variables:

    Runtime:addEventListener( "enterFrame", gameListener )		--> start main.lua's event listener
    nextScreen = "mainmenu"		--> assuming you have a mainmenu.lua screen
    callUnload = true

    Alternatively, you can use the gameOver() function I included. It can
    be called like so:

    gameOver( nextScreen )	--> example: gameOver( "mainmenu" )

    By setting the variables above (or calling the gameOver() function), the main.lua's enterFrame event will
    detect it and call THIS unloadMe function, and then call the init function
    of the screen you set with the 'nextScreen' variable.
        
    ]]--

    -- remove any event listeners
    Runtime:removeEventListener( "enterFrame", levelLoop )

    -- also, don't forget to stop any timers that you created
    -- example:
    -- timer.cancel( myTimer )


    --[[ loop through all groups (that were created at the beginning of the file) and remove their children

    -- example:

    for i=screenGroup.numChildren,1,-1 do
        child = screenGroup[i]
        child.parent:remove( child )
        child = nil
        child.parent = nil
    end

    ]]--

    -- collect any/all garbage
    collectgarbage( "collect" )
    end
--end unloadme
-----------------------------------------------------------------------
-----------------------------------------------------------------------