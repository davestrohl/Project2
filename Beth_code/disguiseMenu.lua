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
    
    --plant disguise
    plantButton = display.newRect(90, 200, 100, 100)
    plantButton:setFillColor(0,255,0)
    disguiseG:insert(plantButton)
    --security guard disguise
    guardButton = display.newRect(290, 200, 100, 100)
    guardButton:setFillColor(0,0, 255)
    disguiseG:insert(guardButton)
    
    --NOTE: next_level is still set to the current level until the level ends
    
    if next_level=="level1map" then
        
    elseif next_level =="level2map" then
        --plant disguise
        --security guard disguise
        --dinosaur disguise
    end
    
    --playButton:addEventListener("touch", push)
    plantButton:addEventListener("touch", plantpush)
    guardButton:addEventListener("touch", guardpush)
end

function plantpush()
    print(level1map.disguise)
    print("you hit the plant buttton")
    level1map.disguise ="plant"
    
end

function guardpush()
    level1map.disguise="guard"
end

function push()
    if disguiseG then
        disguiseG:removeSelf()
    end
    open_menu = true
    collectgarbage("collect")
    --print("HERE")
end