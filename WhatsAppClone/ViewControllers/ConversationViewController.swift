//
//  ConversationViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 07/02/24.


import UIKit
import CometChatSDK

protocol UpdatingLastMessage {
    func changeLastMessage()
}
class ConversationViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    var messageRequest: MessagesRequest?
    var messagesArray : [TextMessage] = []
    var combinedMessagesArray : [(date: String, textMessage: [TextMessage])] = []
    let conversation : Conversation
    var bottomConstraint : NSLayoutConstraint?
    var delegate : UpdatingLastMessage?
    var typingStatus = false
    let imagePicker = UIImagePickerController()
    
    var user : User? = nil
    var group : Group? = nil
    
    
    init(conversation : Conversation){
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let headerView = HeaderView()
    
    let composerView : UIView = {
        let composerView = UIView()
        composerView.layer.cornerRadius = 10
        composerView.backgroundColor = .gray.withAlphaComponent(0.1)
        composerView.translatesAutoresizingMaskIntoConstraints = false
        return composerView
    }()
    
    let textMessageComposer : UIView = {
        let composerView = UIView()
        composerView.layer.cornerRadius = 20
        composerView.backgroundColor = .gray.withAlphaComponent(0.2)
        composerView.translatesAutoresizingMaskIntoConstraints = false
        composerView.backgroundColor = .gray.withAlphaComponent(0.2)
        return composerView
    }()
    
    let plusButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return button
    }()
    
    let cameraButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let micButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type message here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        return textField
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.tintColor = UIColor.white
//        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 18
        return button
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        CometChat.messagedelegate = self
        CometChat.calldelegate = self
        CometChat.userdelegate = self
        imagePicker.delegate = self
        tableView.register(BubbleTableViewCell.self, forCellReuseIdentifier: "BubbleTableViewCell")
        
        //By adding these two lines the whole tableView gets invisible
        navigationItem.hidesBackButton = true
        
        if let navigationBar = navigationController?.navigationBar {
                    // Change the height of the navigation bar title view
                    let navBarHeight = navigationBar.frame.size.height
                    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationBar.frame.size.width, height: 500))
                    navigationItem.titleView = headerView
                }
        
        fetchMessages(limit: 0)
        setUpView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        bottomConstraint = composerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -35)
        bottomConstraint?.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidAppear (_ animated: Bool) {
        tableView.scrollToBottomfunction()
        
    }
    
    private func setUpView() {

        tableView.addSubview(refreshControl)
        view.addSubview(tableView)
        view.addSubview(headerView)
        composerView.addSubview(plusButton)
        textMessageComposer.addSubview(textField)
        textMessageComposer.addSubview(sendButton)
        composerView.addSubview(textMessageComposer)
        composerView.addSubview(cameraButton)
        composerView.addSubview(micButton)
        view.addSubview(composerView)
        
        if let user = conversation.conversationWith as? User {
            let avatarUrl = URL(string: user.avatar ?? "https://picsum.photos/200/300")
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: avatarUrl!),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.headerView.profileImageView.image = image
                    }
                }
            }
            headerView.nameLabel.text = user.name
        }
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(openCameraButton), for: .touchUpInside)
        headerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerView.infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(fetchingPreviousData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...")

        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: composerView.topAnchor, constant: -10),
            
            composerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composerView.heightAnchor.constraint(equalToConstant: 50),
            composerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: composerView.leadingAnchor, constant: 3),
            plusButton.bottomAnchor.constraint(equalTo: composerView.bottomAnchor, constant: -5),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.topAnchor.constraint(equalTo: composerView.topAnchor, constant: 5),
            
            textMessageComposer.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor),
            textMessageComposer.trailingAnchor.constraint(equalTo: cameraButton.leadingAnchor),
            textMessageComposer.bottomAnchor.constraint(equalTo: composerView.bottomAnchor,constant: -7),
            textMessageComposer.topAnchor.constraint(equalTo: composerView.topAnchor,constant: 7),
            
            textField.leadingAnchor.constraint(equalTo: textMessageComposer.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -2),
            textField.bottomAnchor.constraint(equalTo: textMessageComposer.bottomAnchor, constant: -4),
            textField.topAnchor.constraint(equalTo: textMessageComposer.topAnchor, constant: 4),
            
            sendButton.trailingAnchor.constraint(equalTo: textMessageComposer.trailingAnchor,constant: -2),
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 5),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
       
            cameraButton.trailingAnchor.constraint(equalTo: micButton.leadingAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: composerView.bottomAnchor, constant: -5),
            cameraButton.widthAnchor.constraint(equalToConstant: 40),
            cameraButton.topAnchor.constraint(equalTo: composerView.topAnchor, constant: 5),
            
            micButton.trailingAnchor.constraint(equalTo: composerView.trailingAnchor, constant: -5),
            micButton.bottomAnchor.constraint(equalTo: composerView.bottomAnchor, constant: -5),
            micButton.widthAnchor.constraint(equalToConstant: 35),
            micButton.topAnchor.constraint(equalTo: composerView.topAnchor, constant: 5),
        ])
        
        headerView.callButton.addTarget(self, action: #selector(callButtonTappped), for: .touchUpInside)
        headerView.videoCallButton.addTarget(self, action: #selector(callButtonTappped), for: .touchUpInside)
        
    }
    
    func fetchMessages(limit : Int) {
        let user = conversation.conversationWith as? User
        let group = conversation.conversationWith as? Group
        if let UID = user?.uid {
            messageRequest = MessagesRequest.MessageRequestBuilder().set(uid:UID).set(limit: 30 + limit).build();
        }
        if let GUID = group?.guid {
            messageRequest = MessagesRequest.MessageRequestBuilder().set(guid: GUID).set(limit: 30 + limit).set(unread: true).hideDeletedMessages(hide: true).build();
        }
        self.messagesArray.removeAll()
        self.combinedMessagesArray.removeAll()
        messageRequest?.fetchPrevious(onSuccess: { (messages) in
            for message in messages ?? []{
                if let receivedMessage = message as? TextMessage {
                    self.messagesArray.append(receivedMessage)
                } else if let receivedMessage = message as? MediaMessage {
                    print("Message received successfully as mediaMessage")
                }
            }
            
            var currentMessages: [TextMessage] = []
            var groupedMessages = [(date: String, textMessage: [TextMessage])]()
            
            
            for i in 0..<self.messagesArray.count {
                let message = self.messagesArray[i]
                
                if i < self.messagesArray.count - 1 {
                    let nextMessage = self.messagesArray[i+1]
                    
                    if ChatsHelper.shared.changeIntToDate(sentAt: message.sentAt) == ChatsHelper.shared.changeIntToDate(sentAt: nextMessage.sentAt) {
                        currentMessages.append(message)
                    } else {
                        let currentDate = ChatsHelper.shared.changeIntToDate(sentAt: message.sentAt)
                        groupedMessages.append((date: currentDate, textMessage: currentMessages))
                        
                        currentMessages = []
                    }
                } else {
                    currentMessages.append(message)
                    
                    let currentDate = ChatsHelper.shared.changeIntToDate(sentAt: message.sentAt)
                    groupedMessages.append((date: currentDate, textMessage: currentMessages))
                }
            }
            
            self.combinedMessagesArray = groupedMessages
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print("Message receiving failed with error: " + error!.errorDescription);
        }
        
    }
    
    @objc private func fetchingPreviousData(_ sender: Any) {
//            fetchMessages(limit: 30)
            refreshControl.endRefreshing()
        }
    @objc func sendButtonTapped() {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        let user = conversation.conversationWith as? User
        if let receiverID = user?.uid {
            let textMessage = TextMessage(receiverUid: receiverID, text: text, receiverType: .user)
            textMessage.senderUid = CometChat.getLoggedInUser()?.uid ?? ""
            
            CometChat.sendTextMessage(message: textMessage, onSuccess: { (message) in
                print("TextMessage sent successfully. " + message.stringValue())
                var lastElement = self.combinedMessagesArray.last
                if ChatsHelper.shared.changeIntToDate(sentAt: message.sentAt) != lastElement?.date {
                    let dateString = ChatsHelper.shared.changeIntToDate(sentAt: message.sentAt)
                    self.combinedMessagesArray.append((date: dateString, textMessage: [message]))
                }else{
                    lastElement?.textMessage.append(message)
                    self.combinedMessagesArray[self.combinedMessagesArray.count-1] = lastElement!
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //Closures takes time to run so initialize scroll to bottom in closure
                    self.tableView.scrollToBottomfunction()
                }
            }) { (error) in
                print("TextMessage sending failed with error: " + error!.errorDescription);
            }
        }
        textField.text = ""
    }
    
    @objc func backButtonTapped(){
        delegate?.changeLastMessage()
        navigationController?.popViewController(animated: true)
    }
    @objc func plusButtonTapped(){
        let menuOptionsController = MenuOptionsViewController()
        self.present(menuOptionsController,animated: true)
    }
    
    // MARK: Calling Functionality
    @objc func callButtonTappped(){
        let callScreenVC = OutgoingCallScreenController(conversation: conversation)
        callScreenVC.modalPresentationStyle = .fullScreen
        self.present(callScreenVC, animated: true)
        let receiver = conversation.conversationWith as? User
        let receiverID = receiver?.uid
        let receiverType:CometChat.ReceiverType = .user
        let callType: CometChat.CallType = .audio

        let newCall = Call(receiverId: receiverID!, callType: callType, receiverType: receiverType);

        CometChat.initiateCall(call: newCall, onSuccess: { (ongoing_call) in

          print("Call initiated successfully " + ongoing_call!.stringValue());

        }) { (error) in

          print("Call initialization failed with error:  " + error!.errorDescription);

        }
    }
    @objc func infoButtonTapped(){
        let userInformationVC = InfoViewController(conversation: conversation)
        present(userInformationVC, animated: true)
    }
}

extension ConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinedMessagesArray[section].textMessage.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return combinedMessagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BubbleTableViewCell", for: indexPath) as! BubbleTableViewCell
        let message = combinedMessagesArray[indexPath.section].textMessage[indexPath.row]
        cell.configure(with: message.text,with: TimeInterval(message.sentAt), isSentByCurrentUser: message.senderUid == CometChat.getLoggedInUser()?.uid ? true : false)
//        cell.configure2(with: message.text, isOutgoing: message.senderUid == CometChat.getLoggedInUser()?.uid ? true : false)
        return cell
    }
    
    
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = combinedMessagesArray[section].date
                
        let label = DataHeaderLabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = date
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
}
extension UITableView {
    func scrollToBottomfunction (){
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        guard numberOfRows(inSection: lastSection) > 0 else { return }
        let lastRowIndexPath = IndexPath(row: numberOfRows(inSection: lastSection) - 1,section: lastSection)
        scrollToRow(at: lastRowIndexPath, at: .bottom, animated: true)
        
//        let numberOfRows = numberOfRows(inSection: )
//        if numberOfRows > 0 {
//            let indexPath = IndexPath(row: numberOfRows-1, section: 0)
//            scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
    }
}
    //  MARK: For realtime messages
extension ConversationViewController: CometChatMessageDelegate {
    func onTextMessageReceived(textMessage: TextMessage) {
        print("TextMessage received successfully: " + textMessage.stringValue())
        // Append the received message to messagesArray
        var lastElement = self.combinedMessagesArray.last
        lastElement?.textMessage.append(textMessage)
        self.combinedMessagesArray[self.combinedMessagesArray.count-1] = lastElement!
        // Reload the table view to display the new message
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToBottomfunction()
        }
    }

    func onMediaMessageReceived(mediaMessage: MediaMessage) {
        print("MediaMessage received successfully: " + mediaMessage.stringValue())
    }
    
    func onCustomMessageReceived(customMessage: CustomMessage) {
        print("CustomMessage received successfully: " + customMessage.stringValue())
    }
}

//  MARK: For realtime calling
extension ConversationViewController : CometChatCallDelegate {
    func onIncomingCallReceived(incomingCall: CometChatSDK.Call?, error: CometChatSDK.CometChatException?) {
        print(" Incoming call " + incomingCall!.stringValue());
        let incomingCallVC = IncomingScreenViewController(conversation: conversation)
        incomingCallVC.incomingCall = incomingCall
        incomingCall?.sessionID = "call123"
        incomingCallVC.modalPresentationStyle = .fullScreen
        present(incomingCallVC, animated: true)
    }
    
    func onOutgoingCallAccepted(acceptedCall: CometChatSDK.Call?, error: CometChatSDK.CometChatException?) {
        print("Outgoing call " + acceptedCall!.stringValue());
    }
    
    func onOutgoingCallRejected(rejectedCall: CometChatSDK.Call?, error: CometChatSDK.CometChatException?) {
        guard let rejectedCall = rejectedCall else { return }
        print("Rejected call " + rejectedCall.stringValue());
    }
    
    func onIncomingCallCancelled(canceledCall: CometChatSDK.Call?, error: CometChatSDK.CometChatException?) {
        print("Cancelled call " + canceledCall!.stringValue());
    }
    func onCallEndedMessageReceived(endedCall: Call?, error: CometChatException?) {
        print(" Ended call " + endedCall!.stringValue())
    }
    
    //MARK: - Keyboard methods
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint?.constant = -keyboardSize.height - 20
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint?.constant = -35
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

class DataHeaderLabel : UILabel {
    override var intrinsicContentSize: CGSize{
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height/2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
}
extension ConversationViewController : CometChatUserDelegate {
    func onTypingStarted(_ typingDetails : TypingIndicator) {

        print("Typing started received successfully")
        self.headerView.typingLabel.text = "typing..."
      }

      func onTypingEnded(_ typingDetails : TypingIndicator) {
        print("Typing ended received successfully")
          if typingStatus {
              self.headerView.typingLabel.text = "Online"
          }else{
              self.headerView.typingLabel.text = "Offline"
          }
    
      }
    func onUserOnline(user: User) {
          
      print(user.stringValue() + " status becomes online.")
        self.headerView.typingLabel.text = "Online"
        self.headerView.statusDot.backgroundColor = .green
        typingStatus = true
    }
      
    func onUserOffline(user: User) {
          
      print(user.stringValue() + " status becomes offline.")
        self.headerView.typingLabel.text = "Offline"
        self.headerView.statusDot.backgroundColor = .lightGray
        typingStatus = false
    }
}

extension ConversationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Use image here
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
