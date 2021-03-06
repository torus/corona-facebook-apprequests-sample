-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local fbutil = require("fbutil")

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local sum_text
local title_text
local facebook = require "facebook"

function facebook_request_coro(scene, group)
   print("started")

   fbutil.login_coro()

   local res = facebook.showDialog("apprequests",
				   {message = "Help Needed!",
				    title = "Give me money!!",
				    data = "{time=" .. os.time() .. "}"})

   print("showDialog", res)

   -- Wait for the response from the Facebook server
   event = coroutine.yield()
   print("event", event.type)

   assert(event.type == "dialog")

   local res = event.response
   sum_text.text = res
end

function facebook_send_request(scene, group)
   coroutine.wrap(facebook_request_coro)(scene, group)
end

----------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 255 )	-- white
	
	-- create some text
	local title = display.newText( "Warning!", 0, 0, native.systemFont, 32 )
	title:setTextColor( 0 )	-- black
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 125
	
	local summary = display.newText( "This app doesn't work on the Corona Simulator. Please use the Xcode Simulator or an iOS device", 0, 0, 300, 300, native.systemFont, 14 )
	summary:setTextColor( 0 ) -- black
	summary:setReferencePoint( display.CenterReferencePoint )
	summary.x = display.contentWidth * 0.5 + 10
	summary.y = title.y + 215

	title_text = title
	sum_text = summary
	
	-- all objects must be added to group (e.g. self.view)
	group:insert( bg )
	group:insert( title )
	group:insert( summary )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- do nothing
	print("view2 enterScene")
	facebook_send_request(scene, group)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
