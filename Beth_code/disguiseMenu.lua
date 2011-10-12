module(..., package.seeall)
level1map = require("level1map")
function init()
    disguiseG = display.newGroup()
    --print(next_level)
    
    local menuBG = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    menuBG:setFillColor(200, 0, 200, 200)
    disguiseG:insert(menuBG)
    
    -- playButton = display.newRect(140,700, 200, 80)
    -- playButton:setFillColor(255, 255, 255)
    -- disguiseG:insert(playButton)
    
    -- default disguise
    defButton = display.newRect(90, 600, 300, 100)
    defButton:setFillColor(255,255,255)
    disguiseG:insert(defButton)
    --plant disguise
    plantButton = display.newRect(90, 200, 100, 100)
    plantButton:setFillColor(0,255,0)
    disguiseG:insert(plantButton)
    --security guard disguise
    guardButton = display.newRect(290, 200, 100, 100)
    guardButton:setFillColor(0,0, 255)
    disguiseG:insert(guardButton)
    numGuards = display.newText(level1map.guardsLeft, 315, 225, "Helvetica", 52)
    numGuards:setTextColor(255, 255, 255)
    disguiseG:insert(numGuards)
    --dinosaur disguise
    dinoButton = display.newRect(90, 400, 100, 100)
    dinoButton:setFillColor(255, 255, 0)
    disguiseG:insert(dinoButton)
    --NOTE: next_level is still set to the current level until the level ends
    
    if next_level=="level1map" then
        dinoButton.isVisible = false
        defButton:addEventListener("touch", defpush)
        plantButton:addEventListener("touch", plantpush)
        guardButton:addEventListener("touch", guardpush)
    elseif next_level =="level2map" then
        defButton:addEventListener("touch", defpush)
        plantButton:addEventListener("touch", plantpush)
        guardButton:addEventListener("touch", guardpush)
        dinoButton:addEventListener("touch", dinopush)
    end
    
    --playButton:addEventListener("touch", push)
    
end

function defpush()
    if next_level=="level1map" then
        level1map.disguise = "def"
        level1map.direction = "down"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
        end
    elseif next_level =="level2map" then
        level1map.disguise = "def"
        level1map.direction = "down"
        if level2map.player.spr.sequence ~= level2map.disguise then
            level2map.player:pose()
        end
    end
end

function plantpush()
    -- print(level1map.disguise)
    -- print("you hit the plant buttton")
    if next_level=="level1map" then
        level1map.disguise ="down"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
        end
        level1map.disguise ="plant"
    elseif next_level =="level2map" then
        level2map.disguise ="down"
        if level2map.player.spr.sequence ~= level2map.disguise then
            level2map.player:pose()
        end
        level2map.disguise ="plant"
    end
end

function guardpush()
    if next_level=="level1map" then
        level1map.disguise = "left"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
            numGuards.text = level1map.guardsLeft
        end
        level1map.disguise ="guard"
    elseif next_level =="level2map" then
        level2map.disguise = "left"
        if level2map.player.spr.sequence ~= level2map.disguise then
            level2map.player:pose()
            numGuards.text = level2map.guardsLeft
        end
        level1map.disguise ="guard"
    end
end

function dinopush()
    if next_level=="level1map" then
        level1map.disguise = "dino"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
        end
    elseif next_level =="level2map" then
        level2map.disguise = "dino"
        if level2map.player.spr.sequence ~= level2map.disguise then
            level2map.player:pose()
        end
    end
end

function push()
    if disguiseG then
        disguiseG:removeSelf()
    end
    open_menu = true
    collectgarbage("collect")
    --print("HERE")
end