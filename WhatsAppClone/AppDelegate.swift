//
//  AppDelegate.swift
//  WhatsAppClone
//

//  Created by Admin on 06/02/24.
//

import UIKit
import CometChatSDK
import CometChatCallsSDK
//import FirebaseCore
//import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appId: String = Constants.appId
    let region: String = Constants.region
       
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

       let mySettings = AppSettings.AppSettingsBuilder()
                                     .subscribePresenceForAllUsers()
                                     .setRegion(region: region)
                                     .autoEstablishSocketConnection(true)
                                     .build()
               
         CometChat.init(appId: appId ,appSettings: mySettings,onSuccess: { (isSuccess) in
                   if (isSuccess) {
                       print("CometChat Pro SDK intialise successfully.")
                   }
               }) { (error) in
                       print("CometChat Pro SDK failed intialise with error: \(error.errorDescription)")
               }
       
       let host = "HOST"
       let callSettings: CometChatCallsSDK.CallSettings?

       let callAppSettings = CallAppSettingsBuilder()
                   .setAppId(appId)
                   .setRegion(region)
                   .setHost(host)
                   .build()
       let callsettings = CometChatCalls.callSettingsBuilder
       
//       let callAppSettings = callAppSettings

       CometChatCalls.init(callsAppSettings: callAppSettings) { success in
           print("CometChatCalls init success: \(success)")
       } onError: { error in
           print("CometChatCalls init error: \(String(describing: error?.errorDescription))")
       }
       
       if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self

         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
           options: authOptions,
           completionHandler: {
             _,
             _ in
           })
       } else {
         let settings: UIUserNotificationSettings =
           UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
         application.registerUserNotificationSettings(settings)
       }

       application.registerForRemoteNotifications()
//       Messaging.messaging().delegate = self
//       FirebaseApp.configure()
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
        return [[.badge,.alert, .sound]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)
  }
}

//extension AppDelegate : MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//      print("Firebase registration token: \(String(describing: fcmToken))")
//
//      let dataDict: [String: String] = ["token": fcmToken ?? ""]
//      NotificationCenter.default.post(
//        name: Notification.Name("FCMToken"),
//        object: nil,
//        userInfo: dataDict
//      )
//      // TODO: If necessary send token to application server.
//      // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//    func application(application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//      Messaging.messaging().apnsToken = deviceToken
//    }
//
//}
