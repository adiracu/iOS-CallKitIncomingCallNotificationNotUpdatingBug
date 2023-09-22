Minimal CallKit app that showcases an iOS 17.0 bug, filed as FB13184468. 

This is an iPhone 14 (and probably 15) & iOS 17 specific bug, where updates specified via CallKit `CXProvider.reportCall()` are not taken into account.

Steps to reproduce:

1. Unzip CallKitPlayground
2. Run the app on an iPhone 12
3. Run the app on an iPhone 14

## Test Scenarios

The iPhone 12 updates the notification from "Calling" to "Johnny Doe".
The iPhone 14 does not update the notification, it's always shown as "Calling".

1. If the app running in the foreground, screen on -> bug present
2. If the app running in the foreground, screen locked -> no bug
3. If the app is running & backgrounded, screen on ->  bug present
4. If the app is running & backgrounded, screen locked ->  no bug
5. If the app is killed, screen on -> bug present
6. If the app is killed, screen locked ->  no bug

Looks to be a "screen on/locked" bug only, with app foreground state not having an effect.

All the above on iPhone 14 Pro. On iPhone 12 Pro all cases work as expected.



## Context 

That tapping on the iPhone 14 notification to make it full screen does show the correct name.

This sample app tries to simulate a common scenario VoIP apps use, where as soon as they get the PushKit notification, the call is reported to CallKit via `CXProvider.reportNewIncomingCall()` with a hardcoded string value (e.g. "Calling"). This immediately shows up in the UI as a notification showing "Calling", with the main idea to make the phone ring as soon as possible.

Once the SIP handshake is established (~1 second after) the value of that call is updated via `CXProvider.reportCall`. 

This approach has worked well, we've noticed the issue only on iOS 17 & iPhone 14. 

## Possible Causes

Our assumption is that because iPhone 14 has a different implementation of the notification due to the dynamic island. 

## Workarounds

1. Tapping on the banner notification transforms it to a full screen view with the correct information. Seeing as the full screen notifications shows the correct information, it feels like the banner just forgot to redraw itself once it received the updated information. 
2. Having Settings -> Phone -> Incoming Calls set to “Full Screen” instead of "Banner"
3. Instead of calling `CXProvider.reportNewIncomingCall()` immediately with a static string and then updating it via `CXProvider.reportCall()`, wait until the SIP information is received and just report the new incoming call with all the information from the start.

