corona-facebook-apprequests-sample
==================================

Note
----

- Configure the appId in fsutil.lua and build.settings
- see: https://developers.facebook.com/docs/howtos/requests/#delete_requests
- Some functions are implemented with coroutine for asynchronous network communication

Functions
---------

### facebook_get_requests(scene, group)

(view1.lua)
Gets apprequests via Facebook Graph API and show them in a TableView.

### delete_request(req)

(view1.lua)
Delete the apprequest.

### send_request_back(req)
(view1.lua)
Shows the "send-back" dialog for a received request.

### facebook_send_request(scene, group)

(view2.lua)
Show the apprequest dialog.
