--local physics = require("physics")

module(..., package.seeall)

local sprite = require("sprite")
local enemyBody = {density = 1.5, friction = 0.7, bounce = 0.3, radius = 50, isSensor = true}
function newEnemy(x, y, p)
	local g = display.newGroup()
	local enemySheet = sprite.newSpriteSheet("ball_white.png", 72,72)
	local enemySet = sprite.newSpriteSet(enemySheet, 1, 1)
	sprite.add(enemySet, "patrol", 1, 1, 1000)
	local enemy = sprite.newSprite(enemySet)
	--local enemy = display.newImage("ball_white.png")
	enemy.x = x
	enemy.y = y
	enemy.xScale = 0.5
	enemy.yScale = 0.5
    enemy:prepare("patrol")
    enemy:play()
	--local object = {x = x, y = y, sprite = enemy}
	--setmetatable(object, {__index = Enemy})
	--p.addBody(enemy, enemyBody)
	
	--g:insert(enemy)
	
	
	function g:getLocation()
		return {x = x , y = y}
	end
	
	function g:setLocation( loc )
		enemy.x = loc.x; enemy.y = loc.y
	end
	
	function g:move(x , y)
		enemy:applyForce(x, y, enemy.x, enemy.y)
	end
	
	
	return g
end

