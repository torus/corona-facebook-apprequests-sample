local fbutil = {}
local appId = "142151812521022"

function fbutil.login_coro()
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
end

return fbutil
