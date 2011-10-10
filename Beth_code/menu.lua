module(..., package.seeall)
local playnow = 1
callUnload = false
menuGroup = display.newGroup()
function menu()

    local menuBG = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    menuBG:setFillColor(200, 200, 200)
    menuGroup:insert(menuBG)
    
    playButton = display.newRect(display.contentWidth/2 - 100, display.contentHeight/2 - 40, 200, 80)
    playButton:setFillColor(255, 255, 255, 50)
    playButton.id = playnow
    menuGroup:insert(playButton)
    
    playButton:addEventListener("touch", init)
end
function levelOver(n_lvl)
    Runtime: addEventListener("enterFrame", gameListener)
    next_level = n_lvl -- next_level is a global from main.lua
    callUnload = true
end
function init(event)
    mode = event.target.id
    if mode == playnow then
        menu_over()
    end
end
function menu_over()
    callUnload = true
    --next_level = "level1map"
end
function unloadMe()
    --print("unloaded")
    menuGroup:removeSelf()
    playButton:removeEventListener("touch",init)
    collectgarbage("collect")
    return "level1map"
end

menu()