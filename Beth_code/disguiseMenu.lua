module(..., package.seeall)

function init()
    disguiseG = display.newGroup()
    
    local menuBG = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    menuBG:setFillColor(200, 0, 200, 200)
    disguiseG:insert(menuBG)
    
    local playButton = display.newRect(display.contentWidth/2 - 100, display.contentHeight/2 - 40, 200, 80)
    playButton:setFillColor(255, 255, 255)
    --playButton.id = playnow
    disguiseG:insert(playButton)
    
    playButton:addEventListener("touch", push)
end

function push()
    disguiseG:removeSelf()
    collectgarbage("collect")
    print("HERE")
end