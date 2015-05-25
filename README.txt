SIMPLE LOGIN SAMPLE for iOS
----------------------------

Please read the sample Guide for more information at: https://docs.gamedonia.com/samples/simple-login/ios-tutorial


Instructions:
-------------

Before executing this sample, you need to create a game in the Gamedonia Dashboard. To create a Game in Gamedonia:

1) Log into the Gamedonia Dashboard at http://dashboard.gamedonia.com
2) Create a Game.
3) Copy your API key and Secret from the Game Information section.
4) Create an app in the Facebook developers webpage: https://developers.facebook.com/

In Xcode:

- Open the AppDelegate.m file and fill the API key and the Secret with the values you previously copied from the Dashboard.
- Open your Info.plist file and fill fhese fields:
  * FacebookAppID: <your_facebook_app_id>
  * URLTypes/URL Schemes: fb<your_fb_app_id>

For more information, check out our documentation at https://docs.gamedonia.com/