module(..., package.seeall)

--External Modules
sprite = require("sprite")
physics = require("physics")

--Declarations - variables/switches/etc
--make world group
local worldgroup=display.newGroup()
--put big rectangle in world group for touch purposes
local world = display.newRect(0,0,1056,960)
world:setFillColor(128,0,0)
worldgroup:insert(world)



--image file references
DESK = "../gfx/filler_desk.png"
PLANT = "../gfx/filler_plant.png"
--
--
--

--
--
--
--Globals - to be accessed from main.lua
callUnload = false

--Creation Functions
--[[

Place all of your creation functions and any other
functions that might need to be accessed from this
screen's enterFrame event listener.

]]--

local levelOver = function(n_lvl)
    Runtime: addEventListener("enterFrame", gameListener)
    next_level = n_lvl -- next_level is a global from main.lua
    callUnload = true
end

local function penguinFly(event)
    penguin.y = 500 + 300*math.sin(event.time/3000)
end

--levelLoop() this level's enterFrame event
local levelLoop = function (event)
    --[[

    This is your game's main enterFrame event listener.
    This function is called on every frame.

    Think of this kind of like a main() loop.

    ]]--
    penguin:prepare("fly")
    penguin:play()

    end
--init and unloading functions
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

--worldgroup's touch event function
local moveWorld = function(event)
    if event.phase == "ended" then
        delta_x = event.x - event.xStart
        delta_y = event.y - event.yStart
        worldgroup:translate(delta_x, delta_y)
    end
        
end

init=function()
    physics.start()
    --physics.setDrawMode("hybrid")
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
    right = display.newRect(0,1056,0,960)
    physics.addBody(right, "static", {bounce =1})
    worldgroup:insert(right)
    --input penguin for testing purposes
    local penguinSheet = sprite.newSpriteSheet("pixelpenguin.png", 360, 288)
    local penguinSet = sprite.newSpriteSet(penguinSheet, 1, 2)
    sprite.add(penguinSet, "fly", 1, 2, 400)
    penguin = sprite.newSprite(penguinSet)
    penguin.x = 200
    penguin.y=  500
    penguin.xScale = .3
    penguin.yScale = .3
    penguinpoly = {-30, -70, 30, -70, 70, 0, 40, 60, -40, 60, -70, 0}
    physics.addBody(penguin, {density = 1.0, friction =10, bounce = 1, shape=penguinpoly})
    worldgroup:insert(penguin)
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
    -- worldgroup touch eventlistener
    worldgroup:addEventListener("touch", moveWorld)
end

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
