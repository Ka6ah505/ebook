local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------

local background, text, audio
local swipeThreshNext = 100
local swipeThreshPrev = -100

local optionText = {
	text = "Однажды ранним утром он пошел прогуляться в лес...",
	x = 1600,
	y = 1050,
	width = 1000,
	font = native.systemFont,
	fontSize = 98,
	align = "center"
}
---------------------------------------------------------------------------------

local function onPageSwap( event )
    if event.phase == "moved" then
        print( "moved phase" )
        
    elseif event.phase == "ended" or event.phase == "cancelled" then
    	local distance = event.xStart - event.x
    	if distance > swipeThreshNext then
	    	storyboard.removeScene( "scene2" )
			storyboard.gotoScene( "scene3", "fade", 400  )
		elseif distance < swipeThreshPrev and distance < 0 then
			storyboard.removeScene( "scene2" )
			storyboard.gotoScene( "scene1", "fade", 400  )
	    end
        display.getCurrentStage():setFocus( nil )
    end
    
    return true
end

local function audioClock( event )
	-- body
	if event.phase == "began" then
		media.playSound( "kuku.mp3" )
	else
		media.stopSound( "kuku.mp3" )
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view


	background = display.newImageRect( "scene2.png", display.contentWidth, display.contentHeight)
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = 0, 0
	group:insert( background )

	clock = display.newImageRect( "clock.png", display.contentWidth/4, display.contentHeight/2 )
	clock.x = display.contentWidth - 400
	clock.y = display.contentHeight/3
	group:insert( clock )

	text = display.newText( optionText )
	text:setFillColor( 255, 255, 255 )
	group:insert( text )

	print( "\n2: createScene event")

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	print( "2: enterScene event" )

	background:addEventListener( "touch", onPageSwap )
	clock:addEventListener ( "touch", audioClock )

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	print( "2: destroyScene" )

	background:removeEventListener( "touch", onPageSwap )
	clock:removeEventListener( "touch", audioClock )

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