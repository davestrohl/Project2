--local physics = require("physics")

module(..., package.seeall)

local sprite = require("sprite")

function newEnemy(x, y)
	local g = display.newGroup()
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
	--local object = {x = x, y = y, sprite = enemy}
	--setmetatable(object, {__index = Enemy})
	
	function g:getLocation()
		return {x = x , y = y}
	end
	
	function g:setLocation( loc )
		enemy.x = loc.x; enemy.y = loc.y
	end
	
	return g
end

