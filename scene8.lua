local storyboard = require( "storyboard" )
local scene = storyboard.newScene() 
---------------------------------------------------------------------------------

local background, text 
local swipeThreshNext = 100
local swipeThreshPrev = -100

local optionText = {
	text = "Ёжик извинился и подарил ему красивое красное яблоко... они подружились и стали добрыми друзьями...",
	x = 680,
	y = 1400,
	width = 1300,
	font = native.systemFont,
	fontSize = 68,
	align = "center"
}
---------------------------------------------------------------------------------

local function onPageSwap( event )
	local distance
    if event.phase == "moved" then
        print( "moved phase" )
        
    elseif event.phase == "ended" or event.phase == "cancelled" then
    	distance = event.xStart - event.x
    	if distance > swipeThreshNext then
	    	storyboard.removeScene( "scene8" )
			storyboard.gotoScene( "scene9", "fade", 400  )
		elseif distance < swipeThreshPrev and distance < 0 then
			storyboard.removeScene( "scene8" )
			storyboard.gotoScene( "scene7", "fade", 400  )
	    end
        display.getCurrentStage():setFocus( nil )
    end
    
    return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	background = display.newImageRect( "scene8.png", display.contentWidth, display.contentHeight)
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = 0, 0
	group:insert( background )

	text = display.newText( optionText )
	text:setFillColor( 255, 255, 255)
	group:insert( text )

	print( "\n1: createScene event")

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	print( "1: enterScene event" )

	background:addEventListener( "touch", onPageSwap)

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view

	background:removeEventListener( "touch", onPageSwap)

end

---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene