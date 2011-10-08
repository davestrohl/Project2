module(..., package.seeall)
local playnow = 1
function menu()
    menuGroup = display.newGroup()
    
    local menuBG = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    menuBG.setFillColor(200, 200, 200)
    menuGroup:insert(menuBG)
    
    local playButton = display.new(display.contentWidth/2 - 100, display.contentHeight/2 - 40, 200, 80)
    playButton.setFillColor(255, 255, 255, 50)
    playButton.id = playnow
    menuGroup:insert(playButton)
    
    playButtor:addEventListener("touch", init)
end

function init(event)
    mode = event.target.id
    if mode = playnow then
        exit()
    end
end

menu()