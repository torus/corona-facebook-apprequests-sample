-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require("widget")
local json = require("json")
local fbutil = require("fbutil")

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

   fbutil.login_coro()

   -- Get the app requests from friends
   local res = facebook.request("me/apprequests")

   -- Wait for the response
   event = coroutine.yield()
   assert(event.type == "request")

   local response = json.decode(event.response)

   -- First, clear the request_list table
   while #request_list > 0 do
      table.remove(request_list)
   end

   -- Then, populate the requests from friends into the table
   for i, v in ipairs(response.data) do
      table.insert(request_list, v)
   end

   -- Clear and populate the TableView
   table_view:deleteAllRows()
   for i, v in ipairs(request_list) do
      addItem(table_view)
   end
end


function facebook_delete_request_coro(req)
   print("facebook_delete_request_coro started")

   fbutil.login_coro()

   -- Delete the request
   -- https://developers.facebook.com/docs/howtos/requests/#delete_requests
   local res = facebook.request(req.id, "DELETE")

   -- Wait for the response
   event = coroutine.yield()
   print("event", event.type)

   assert(event.type == "request")

   local response = json.decode(event.response)
   print("Deleting request", req.id, "response", response)

   -- Redraw the tableView
   scene:enterScene()
end

function delete_request(req)
   coroutine.wrap(facebook_delete_request_coro)(req)
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
	 print( "id:", requests[event.target.index].id)
	 delete_request(requests[event.target.index])
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

   -- Insert the row into the tableView
   tableView:insertRow
   {
      isCategory = isCategory,
      rowHeight = rowHeight,
      rowColor = rowColor,
      lineColor = lineColor,
   }
end

function facebook_get_requests(scene, group)
   coroutine.wrap(facebook_get_requests_coro)(scene, group)
end

----------------------------------------------------------------------

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
	facebook_get_requests(scene, group)
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
