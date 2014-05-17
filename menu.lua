local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
 
---------------------------------------------------------------------------------
-- Место  для объявления локальных переменных
local background

---------------------------------------------------------------------------------
 
function onSceneTouch( event )
	-- body
	if event.phase == "began" then	
		storyboard.removeScene( "menu" )	
		storyboard.gotoScene( "scene1", "fade", 400  )		
		return true
	end
end

-- Вызывается когда сцена ещё не существует:
function scene:createScene( event )
	local group = self.view
 
	background = display.newImageRect( "menu.png", display.contentWidth, display.contentHeight )
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = 0, 0
	group:insert( background )

	print( "\nmenu: createScene event")
	
end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	print( "menu: enterScene event" )

	background:addEventListener( "touch", onSceneTouch)

end
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	print( "menu: destroyScene")

	background:removeEventListener( "touch", onSceneTouch)
end
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
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