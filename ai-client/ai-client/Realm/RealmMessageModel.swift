//
//  RealmMessageModel.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import Foundation
import RealmSwift

final class RealmMessageModel: Object {
    @objc dynamic var senderId = ""
    @objc dynamic var senderName = ""
    @objc dynamic var messageId = ""
    @objc dynamic var message = ""
    @objc dynamic var sentTimestamp = 0
    
    convenience init(senderId: String, senderName: String, messageId: String, message: String, sentTimestamp: Int) {
        self.init()
        self.senderId = senderId
        self.senderName = senderName
        self.messageId = messageId
        self.message = message
        self.sentTimestamp = sentTimestamp
    }
}
