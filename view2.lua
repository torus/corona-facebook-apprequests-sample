-----------------------------------------------------------------------------------------
--
-- view2.lua
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

local sum_text
local title_text
local facebook = require "facebook"

function facebook_request_coro(scene, group)
   print("started")

   local appId = "142151812521022"
   local coro = coroutine.running()

   print("coro", coro)

   local ret = facebook.login(
      appId,
      function(event)
	 print("resume", event.type)
	 if coroutine.status(coro) == "normal" then
	    timer.performWithDelay(1,
				   function()
				      local res, err = coroutine.resume(coro, event)
				      print(res, err)
				   end
	    )
	 else
	    local res, err = coroutine.resume(coro, event)
	    print(res, err)
	 end
      end,
      {"publish_stream"})

   print("login", res)

   local event = coroutine.yield()

   print("event", event.type)

   assert(event.type == "session")

   print("event.phase", event.phase)

   while event.phase ~= "login" do
      print("event.phase", event.phase)
      event = coroutine.yield()
   end
   res = facebook.showDialog("apprequests",
			     {message = "Help Needed!",
			      title = "Give me money!!",
			      data = "{stage=123}"})

   print("showDialog", res)

   event = coroutine.yield()
   print("event", event.type)

   assert(event.type == "dialog")

   local res = event.response
   sum_text.text = res
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 255 )	-- white
	
	-- create some text
	local title = display.newText( "Second View", 0, 0, native.systemFont, 32 )
	title:setTextColor( 0 )	-- black
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 125
	
	local summary = display.newText( "Loaded by the first tab 'onPress' listener\n— specified in the 'tabButtons' table.", 0, 0, 300, 300, native.systemFont, 14 )
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
	coroutine.wrap(facebook_request_coro)(scene, group)
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
