//
//  ChatViewController.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit
import MessageKit
import SPIndicator

struct User: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
}

class ChatViewController: MessagesViewController {
    
    var messages = [Message]()
    let user = User(senderId: SettingsManager.shared.senderId, displayName: SettingsManager.shared.senderName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deleteObservers()
    }
    
    private func getMessages() {
        RealmManager<RealmMessageModel>().read().forEach { message in
            let user = User(senderId: message.senderId, displayName: message.senderName)
            let sentDate = Date(timeIntervalSince1970: TimeInterval(message.sentTimestamp))
            let message = Message(sender: user, messageId: message.messageId, sentDate: sentDate, kind: .text(message.message))
            self.messages.append(message)
        }
        
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    private func setupInterface() {
        setupNavigationController()
        setupInputBar()
        setupCollectionView()
    }
    
    private func setupNavigationController() {
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.tintColor = UIColor.systemPurple
    }
    
    private func setupInputBar() {
        messageInputBar.sendButton.setTitleColor(UIColor.systemPurple, for: .normal)
        messageInputBar.tintColor = UIColor.systemPurple
        messageInputBar.sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        messageInputBar.inputTextView.placeholder = "Type a message"
    }
    
    private func setupCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Обрабатываем уведомление о появлении клавиатуры
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        scrollToLastMessage(animated: true)
    }
    
    // Обрабатываем уведомление о скрытии клавиатуры
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        scrollToLastMessage(animated: true)
    }
    
    // Прокручиваем к последнему сообщению
    private func scrollToLastMessage(animated: Bool) {
        let lastSection = messagesCollectionView.numberOfSections - 1
        if lastSection >= 0 {
            let lastItem = messagesCollectionView.numberOfItems(inSection: lastSection) - 1
            if lastItem >= 0 {
                let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
                messagesCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    private func isLastSectionVisible() -> Bool {
      guard !messages.isEmpty else { return false }

      let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
      return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    private func setTypingIndicatorViewHidden(_ isHidden: Bool, animated: Bool) {
        if isHidden {
            self.navigationItem.title = "Chat"
        } else {
            self.navigationItem.title = "Chat is generating..."
        }
    }
    
    @objc private func sendAction(_ sender: Any) {
        guard let text = messageInputBar.inputTextView.text else { return }
        
        setTypingIndicatorViewHidden(false, animated: true)
        OpenAiProvider.shared.sendMessage(message: text) { responseMessage in
            self.setTypingIndicatorViewHidden(true, animated: true)
            guard let message = responseMessage.messages.first else {
                SPIndicator.present(title: "Error", message: "No response message", preset: .error, haptic: .error, from: .top)
                return
            }
            
            let sender = User(senderId: responseMessage.senderId, displayName: "AI")
            let messageObj = Message(sender: sender, messageId: responseMessage.messageId, sentDate: Date(timeIntervalSince1970: TimeInterval(responseMessage.sentTimestamp)), kind: .text(message.message))
            let dbMessage = RealmMessageModel(senderId: responseMessage.senderId, senderName: responseMessage.senderName, messageId: responseMessage.messageId, message: message.message, sentTimestamp: responseMessage.sentTimestamp)
            RealmManager<RealmMessageModel>().write(object: dbMessage)
            self.messages.append(messageObj)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        } failure: { error in
            SPIndicator.present(title: "Error", message: error, preset: .error, haptic: .error, from: .top)
        }
        
        let sentDate = Date()
        let messageId = UUID().uuidString
        let message = Message(sender: currentSender(), messageId: messageId, sentDate: sentDate, kind: .text(text))
        let dbMessage = RealmMessageModel(senderId: currentSender().senderId, senderName: currentSender().displayName, messageId: messageId, message: text, sentTimestamp: Int(sentDate.timeIntervalSince1970))
        RealmManager<RealmMessageModel>().write(object: dbMessage)
        messages.append(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
        messageInputBar.inputTextView.text = ""
    }
    
    private func deleteObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: MessagesLayoutDelegate {
}

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.systemPurple : UIColor.systemPurple.withAlphaComponent(0.8)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message) {
            avatarView.set(avatar: Avatar(image: UIImage(systemName: "person.fill")))
            avatarView.tintColor = UIColor.systemPurple
            avatarView.backgroundColor = UIColor.clear
        } else {
            avatarView.set(avatar: Avatar(image: UIImage(named: "aiImage")))
        }
    }
}
