module(...,package.seall)
--External Modules
--like enemy and player etc
--here
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

init=function()
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
    Runtime:addEventListener( "enterFrame", screenLoop )
end

unloadMe = function()
--clear everything at end of level
    -- remove any event listeners
    Runtime:removeEventListener( "enterFrame", screenLoop )

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
