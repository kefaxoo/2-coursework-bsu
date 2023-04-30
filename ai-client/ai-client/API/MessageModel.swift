//
//  MessageModel.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import Foundation
import ObjectMapper

final class MessageModel: Mappable {
    var senderId = ""
    var messages = [ChoiceModel]()
    var sentTimestamp = 0
    var messageId = ""
    var senderName = ""
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        senderId      <- map["model"]
        messages      <- map["choices"]
        sentTimestamp <- map["created"]
        messageId     <- map["id"]
    }
}

final class ChoiceModel: Mappable {
    var message = ""
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        message <- map["message.content"]
    }
}
