local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------

local background, text, rect
local swipeThreshNext = 100
local swipeThreshPrev = -100

local optionText = {
	text = "Ёжик весело подпрыгивал и пел песенки.",
	x = 1100,
	y = 1380,
	width = 2000,
	font = native.systemFont,
	fontSize = 108,
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
	    	storyboard.removeScene( "scene4" )
			storyboard.gotoScene( "scene5", "fade", 400  )
		elseif distance < swipeThreshPrev and distance < 0 then
			storyboard.removeScene( "scene4" )
			storyboard.gotoScene( "scene3", "fade", 400  )
	    end
        display.getCurrentStage():setFocus( nil )
    end
    
    return true
end

local function isVisibleRect( event )
	-- body
	if event.phase == "began" then
		media.playSound( "smile.mp3" )
	else
		media.stopSound( "smile.mp3" )
	end
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	background = display.newImageRect( "scene4.png", display.contentWidth, display.contentHeight)
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = 0, 0
	group:insert( background )

	text = display.newText( optionText )
	text:setFillColor( 255, 255, 255)
	group:insert( text )

	rect = display.newRect( 1500, 1000, 500, 500 )
	rect:setFillColor( 54, 54, 76)
	rect.alpha = 0.01
	group:insert( rect )

	print( "\n1: createScene event")

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	print( "1: enterScene event" )

	background:addEventListener( "touch", onPageSwap)
	rect:addEventListener( "touch", isVisibleRect)

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view

	background:removeEventListener( "touch", onPageSwap)
	rect:removeEventListener( "touch", isVisibleRect)

end

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