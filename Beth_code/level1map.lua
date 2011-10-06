module(..., package.seeall)

--External Modules
sprite = require("sprite")
scrollView = require("scrollView")
local topBoundary = display.screenOriginY -100
local bottomBoundary = display.screenOriginY + 48
local scrollView = scrollView.new{top=topBoundary, bottom = bottomBoundary}
--
--
--
--Declarations - variables/switches/etc
--here
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

--levelLoop() this level's enterFrame event

local levelLoop = function (event)
    --[[

    This is your game's main enterFrame event listener.
    This function is called on every frame.

    Think of this kind of like a main() loop.

    ]]--

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

init=function()
    --map initialization
    --read in from file
    local path = system.pathForFile("test.txt", system.ResourceDirectory)
    print(path)
    local fh, reasion = io.open(path, "r") -- io.open opens a file at path - returns nil if no file found
    if fh then
        while true do
            local line = fh:read()
            if line == nil then break end
            line = split(line, " ")
            file = line[1]
            x = line[2]
            y = line[3]
            print(v)
            local playerSheet = sprite.newSpriteSheet(file, 100, 100)
            local playerSet = sprite.newSpriteSet(playerSheet,1,1)
            sprite.add(playerSet, "def", 1, 1, 1000)
            local player = sprite.newSprite(playerSet)
            player.x = x
            player.y = y
            player.xScale = 1
            player.yScale = 1
            scrollView:insert(player)
        end
    else
        print("fail")
    end
    --local playerSheet = sprite.newSpriteSheet("gfx/floor_tile.jpg", 72, 72)
    -- local playerSet = sprite.newSpriteSet(playerSheet, 1, 1)
    -- sprite.add(playerSet, "def", 1, 1, 1000)
    -- local player = sprite.newSprite(playerSet)
    -- player.x = display.contentWidth / 3
    -- player.y = display.contentHeight / 3
    -- player.xScale = 0.5
    -- player.yScale = 0.5
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
end

unloadMe = function()

    --[[

    This is what is called when the screen is unloaded.

    For example, you probably want to unload this screen when the
    player has a game over. So when a game over is detected (gameLives == 0),
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
