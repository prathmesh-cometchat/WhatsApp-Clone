//
//  ChatsHelper.swift
//  WhatsAppClone
//
//  Created by Admin on 06/02/24.
//

import Foundation
import CometChatSDK

class ChatsHelper {
    
    static let shared = ChatsHelper()
    func LoginUserMethod(uid : String) -> Bool {
        let authKey = Constants.authKey
        var flag = true

        if CometChat.getLoggedInUser() == nil {
            
            CometChat.login(UID: uid, apiKey: authKey, onSuccess: { (user) in
                DispatchQueue.main.async {
                    if let token = UserDefaults.standard.value(forKey: "fcmToken") as? String {
                        CometChat.registerTokenForPushNotification(token: token, onSuccess: { (success) in
                            print("onSuccess to registerTokenForPushNotification: \(success)")
                            print("Token registered Successfully")
                        }) { (error) in
                            print("error to registerTokenForPushNotification")
                        }
                    }
                }
                
                print("Login successful : " + user.stringValue())
                flag = true
                
            }) { (error) in
                
                print("Login failed with error: " + error.errorDescription);
                flag = false
            }
        }
//        registerManuallyForPushNotifications()
        return flag
    }
    func changeIntToDate(sentAt : Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(sentAt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    func registerManuallyForPushNotifications(){
        CometChat.login(UID: Constants.UID, authKey: Constants.authKey, onSuccess: { (user) in
            DispatchQueue.main.async {
                if let token = UserDefaults.standard.value(forKey: "fcmToken") as? String {
                    CometChat.registerTokenForPushNotification(token: token, onSuccess: { (success) in
                        print("onSuccess to registerTokenForPushNotification: \(success)")
                    }) { (error) in
                        print("error to registerTokenForPushNotification")
                    }
                }
            }
        }, onError: {error in
            print("Error")
        })
    }
}

class Chat {
    // Declare 'conversationRequest' as a class-level property.
    static let shared = Chat()
    var conversationRequest: ConversationRequest?
    var groupsRequest: GroupsRequest?
    var conversationArray : [Conversation] = []
    
    init() {
        // Initialize 'coversationRequest' with the desired configuration.
//        conversationRequest = ConversationRequest.ConversationRequestBuilder(limit: 20).setConversationType(conversationType: .user).build()
    }
    
    func fetchConversation(onSuccess: @escaping ((_: Bool) -> ())) {
        
        conversationRequest = ConversationRequest.ConversationRequestBuilder(limit: 20).setConversationType(conversationType: .user).build()
//        groupsRequest = GroupsRequest.GroupsRequestBuilder(limit: 20).build()
        
//        conversationRequest?.fetchNext(onSuccess: { (groups) in
//
//          for group in groups {
//
//            print("Groups list fetched successfully. " + group.stringValue())
//          }
//
//        }) { (error) in
//
//            print("Groups list fetching failed with error:" + error!.errorDescription);
//        }
        
        conversationRequest?.fetchNext(onSuccess: { (conversationList) in
                    
            print("success of convRequest \(conversationList)")
            
            for conversation in conversationList {
                self.conversationArray.append(conversation)
            }
            onSuccess(true)
        }) { (exception) in
                    
          print("here exception \(String(describing: exception?.errorDescription))")
            onSuccess(false)
        }
        
//        conversationRequest = ConversationRequest.ConversationRequestBuilder(limit: 20).setConversationType(conversationType: .user).build()

//        usersRequest.fetchNext(onSuccess: { [weak self] (conversationList) in
//                    DispatchQueue.main.async {
//                        
//                        print(userList)
//                        
//                        guard let self = self else { return }
//                        self.users = userList.map {
//                            UserModel(
//                                uid: $0.uid ?? "",
//                                name: $0.name ?? "",
//                                isOnline: $0.status == .online,
//        var usersRequest = UsersRequest.UsersRequestBuilder(limit: 40).friendsOnly(false)
//                .hideBlockedUsers(true)
//                .build()
        
        
    }
}


