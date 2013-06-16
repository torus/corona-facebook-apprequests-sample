-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require("widget")
local json = require("json")

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
local request_list
local facebook = require "facebook"


function facebook_get_requests_coro(scene, group)
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

   res = facebook.request("me/apprequests")

   event = coroutine.yield()
   print("event", event.type)

   assert(event.type == "request")

   local response = json.decode(event.response)
   for i, v in ipairs(response.data) do
      table.insert(request_list, v)
   end

   for i, v in ipairs(request_list) do
      addItem(table_view)
   end

end


function create_table()
   local function tableViewListener( event )
      local phase = event.phase
      local row = event.target

      print( event.phase )
   end

   local requests = {}

   -- Handle row rendering
   local function onRowRender( event )
      local phase = event.phase
      local row = event.row

      local req = requests[row.index]
      local text = req.from.name .. " " .. tostring(req.data)
      local rowTitle = display.newText( row, text, 0, 0, nil, 14 )
      rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
      rowTitle.y = row.contentHeight * 0.5
      rowTitle:setTextColor( 0, 0, 0 )
   end

   -- Handle touches on the row
   local function onRowTouch( event )
      local phase = event.phase

      if "press" == phase then
	 print( "Touched row:", event.target.index )
      end
   end

   local tableView = widget.newTableView {
      top = 30,
      left = 20,
      width = 320, 
      height = 300,
      listener = tableViewListener,
      onRowRender = onRowRender,
      onRowTouch = onRowTouch,
   }

   return tableView, requests
end

function addItem(tableView)
   local isCategory = false
   local rowHeight = 40
   local rowColor = 
      { 
	 default = { 255, 255, 255 },
      }
   local lineColor = { 220, 220, 220 }

   -- Make some rows categories
   -- if i == 25 or i == 50 or i == 75 then
   --    isCategory = true
   --    rowHeight = 24
   --    rowColor = 
   -- 	 { 
   -- 	    default = { 150, 160, 180, 200 },
   -- 	 }
   -- end

   -- Insert the row into the tableView
   tableView:insertRow
   {
      isCategory = isCategory,
      rowHeight = rowHeight,
      rowColor = rowColor,
      lineColor = lineColor,
   }
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
   print("createScene")
	local group = self.view
	
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 255 )	-- white
	
	-- create some text
	local title = display.newText( "First View", 0, 0, native.systemFont, 32 )
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

	table_view, request_list = create_table()

	group:insert(table_view)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- Do nothing
	print("view1 enterScene")
	coroutine.wrap(facebook_get_requests_coro)(scene, group)
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
