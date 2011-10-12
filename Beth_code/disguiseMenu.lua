module(..., package.seeall)
level1map = require("level1map")
function init()
    disguiseG = display.newGroup()
    --print(next_level)
    
    local menuBG = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    menuBG:setFillColor(0, 0, 0, 200)
    disguiseG:insert(menuBG)
    
    -- playButton = display.newRect(140,700, 200, 80)
    -- playButton:setFillColor(255, 255, 255)
    -- disguiseG:insert(playButton)
    
    -- default disguise
    defButton = display.newRect(90, 700, 300, 100)
    defButton:setFillColor(255,255,255)
    defText = display.newText("No Disguise", 115, 730, "Helvetica", 42)
    defText:setTextColor(0,0,0)
    disguiseG:insert(defButton)
    disguiseG:insert(defText)
    
    --plant disguise
    plantButton = display.newImage("../gfx/paper_plant.png", 70, 100)
    numPlants = display.newText(level1map.plantsLeft, 70, 273, "Helvetica", 52)
    numPlants:setTextColor(0,0,0)
    disguiseG:insert(plantButton)
    disguiseG:insert(numPlants)
    
    --security guard disguise
    guardButton = display.newImage("../gfx/paper_guard.png", 270, 100)
    numGuards = display.newText(level1map.guardsLeft, 270, 273, "Helvetica", 52)
    numGuards:setTextColor(0, 0, 0)
    disguiseG:insert(guardButton)
    disguiseG:insert(numGuards)
    
    --dinosaur disguise
    dinoButton = display.newImage("../gfx/paper_dinosaur.png", 70, 400)
    numDinos = display.newText(level1map.dinosLeft, 70, 573, "Helvetica", 52)
    numDinos:setTextColor(0,0,0)
    disguiseG:insert(dinoButton)
    disguiseG:insert(numDinos)
    
    --statue disguise
    statueButton = display.newImage("../gfx/paper_statue_f.png", 270, 400)
    numStatues = display.newText(level1map.statuesLeft, 270, 573, "Helvetica", 52)
    numStatues:setTextColor(0,0,0)
    disguiseG:insert(statueButton)
    disguiseG:insert(numStatues)
    --NOTE: next_level is still set to the current level until the level ends
    
    if next_level=="level1map" then
        dinoButton.isVisible = false
        numDinos.isVisible = false
        statueButton.isVisible = false
        numStatues.isVisible = false
        defButton:addEventListener("touch", defpush)
        plantButton:addEventListener("touch", plantpush)
        guardButton:addEventListener("touch", guardpush)
        -- dinoButton:addEventListener("touch", dinopush)
        -- statueButton:addEventListener("touch", statuepush)
    elseif next_level =="level2map" then
        defButton:addEventListener("touch", defpush)
        plantButton:addEventListener("touch", plantpush)
        guardButton:addEventListener("touch", guardpush)
        dinoButton:addEventListener("touch", dinopush)
        --statueButton:addEventListener("touch", statuepush)
    end
    
    --playButton:addEventListener("touch", push)
    
end

function defpush()
    -- if next_level=="level1map" then
        level1map.disguise = "def"
        level1map.direction = "down"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
        end
    -- elseif next_level =="level2map" then
        -- level1map.disguise = "def"
        -- level1map.direction = "down"
        -- if level2map.player.spr.sequence ~= level2map.disguise then
            -- level2map.player:pose()
        -- end
    -- end
end

function plantpush()
    -- print(level1map.disguise)
    -- print("you hit the plant buttton")
    -- if next_level=="level1map" then
        level1map.disguise ="plant"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
            numPlants.text = level1map.plantsLeft
        end
    -- elseif next_level =="level2map" then
        -- level2map.disguise ="down"
        -- if level2map.player.spr.sequence ~= level2map.disguise then
            -- level2map.player:pose()
        -- end
        -- level2map.disguise ="plant"
    -- end
end

function guardpush()
    -- if next_level=="level1map" then
        level1map.disguise ="guard"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
            numGuards.text = level1map.guardsLeft
        end
    -- elseif next_level =="level2map" then
        -- level2map.disguise = "left"
        -- if level2map.player.spr.sequence ~= level2map.disguise then
            -- level2map.player:pose()
            -- numGuards.text = level2map.guardsLeft
        -- end
        -- level1map.disguise ="guard"
    -- end
end

function dinopush()
    -- if next_level=="level1map" then
        level1map.disguise = "dino"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
            numDinos.text = level1map.dinosLeft
        end
    -- elseif next_level =="level2map" then
        -- level2map.disguise = "dino"
        -- if level2map.player.spr.sequence ~= level2map.disguise then
            -- level2map.player:pose()
        -- end
    -- end
end

function statuepush()
    -- if next_level=="level1map" then
        level1map.disguise = "statue"
        if level1map.player.spr.sequence ~= level1map.disguise then
            level1map.player:pose()
            numStatues.text = level1map.statuesLeft
        end
    -- elseif next_level =="level2map" then
        -- level2map.disguise = "statue"
        -- if level2map.player.spr.sequence ~= level2map.disguise then
            -- level2map.player:pose()
        -- end
    -- end
end

function push()
    if disguiseG then
        disguiseG:removeSelf()
    end
    open_menu = true
    collectgarbage("collect")
    --print("HERE")
end