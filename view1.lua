-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- -- create a white background to fill screen
	-- local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	-- bg:setFillColor( 255 )	-- white
	
	-- -- create some text
	-- local title = display.newText( "First View", 0, 0, native.systemFont, 32 )
	-- title:setTextColor( 0 )	-- black
	-- title:setReferencePoint( display.CenterReferencePoint )
	-- title.x = display.contentWidth * 0.5
	-- title.y = 125
	
	-- local summary = display.newText( "Loaded by the first tab 'onPress' listener\n— specified in the 'tabButtons' table.", 0, 0, 300, 300, native.systemFont, 14 )
	-- summary:setTextColor( 0 ) -- black
	-- summary:setReferencePoint( display.CenterReferencePoint )
	-- summary.x = display.contentWidth * 0.5 + 10
	-- summary.y = title.y + 215
	
	-- -- all objects must be added to group (e.g. self.view)
	-- group:insert( bg )
	-- group:insert( title )
	-- group:insert( summary )



	---------------
	local facebook = require "facebook"

	print(facebook)

	-- listener for "fbconnect" events
	local function listener( event )
	   if ( "session" == event.type ) then
	      -- upon successful login, request list of friends of the signed in user
	      if ( "login" == event.phase ) then
		 facebook.request( "me/friends" )

		 -- Fetch access token for use in Facebook's API
		 local access_token = event.token
		 print( access_token )
	      end
	   elseif ( "request" == event.type ) then
	      -- event.response is a JSON object from the FB server
	      local response = event.response

	      -- if request succeeds, create a scrolling list of friend names
	      if ( not event.isError ) then
		 response = json.decode( event.response )

		 local data = response.data
		 for i=1,#data do
		    local name = data[i].name
		    print( name )
		 end
	      end
	   elseif ( "dialog" == event.type ) then
	      print( "dialog", event.response )
	   end
	end

	-- NOTE: You must provide a valid application id provided from Facebook
	local appId = "142151812521022"
	if ( appId ) then
	   facebook.login( appId, listener, {"publish_stream"} )
	else
	   local function onComplete( event )
	      system.openURL( "http://developers.facebook.com/setup" )
	   end

	   native.showAlert( "Error", "To develop for Facebook Connect, you need to get an application id from Facebook's website.", { "Learn More" }, onComplete )
	end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- Do nothing
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
