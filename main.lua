-- main.lua
-- first try

local physics = require("physics")
local sprite = require("sprite")

physics.start()

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 200)

physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight --Screen Size properties
local playerSheet = sprite.newSpriteSheet("gfx/ball_white.png", 72, 72)
local playerSet = sprite.newSpriteSet(playerSheet, 1, 1)
sprite.add(playerSet, "def", 1, 1, 1000)
local player = sprite.newSprite(playerSet)
player.x = display.contentWidth / 2
player.y = display.contentHeight / 2
player.xScale = 0.5
player.yScale = 0.5
local maxVel = 100

player:prepare("def")
player:play()

local playerBody = {density = 1.5, friction = 0.5, bounce = .3}
physics.addBody(player, playerBody)

player.linearDamping = 0.7

-- local edge1 = display.newRect(0, display.contentHeight/2 + 50, display.contentWidth, 10)
-- physics.addBody(edge1, "static", {bounce = 0.7})

-- local function playerMove(x, y)
    -- local dx = (event.x - player.x)
    -- local dy = (event.y - player.y)
    -- local hp = (dx^2 + dy^2)^(0.5)
    -- local xvel = (dx/hp)*maxVel
    -- local yvel = (dy/hp)*maxVel
    -- while player.x ~= x and player.y ~= y do
        -- --player:setLinearVelocity(xvel, yvel)
    -- end
    -- player:setLinearVelocity(0, 0)
-- end
local function playerTouch(event)
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
            local dx = (event.x - player.x)
            local dy = (event.y - player.y)
            local hp = (dx^2 + dy^2)^(0.5)
            -- local xvel = (dx/hp)*maxVel
            -- local yvel = (dy/hp)*maxVel
            -- player:setLinearVelocity(xvel, yvel)
            -- transition.to(event.target, {time = hp * 10, x = event.x, y = event.y})
            
            t:applyForce( (event.x - t.x), (event.y - t.y), t.x, t.y )	
            --player:applyLinearImpulse(50*(dx/hp), 50*(dy/hp), player.x, player.y)
        end
    end
end

-- local function onCollide(event)
    -- if event.object1 == player or event.object2 == player then
        -- player.x = event.x
        -- player,y = event.y
    -- end
-- end

player:addEventListener("touch", playerTouch)
--Runtime:addEventListener("collision", onCollide)