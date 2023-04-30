//
//  OpenAiApi.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import Foundation
import Moya

enum OpenAiApi {
    case sendMessage(text: String)
}

extension OpenAiApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openai.com/v1")!
    }
    
    var path: String {
        switch self {
            case .sendMessage:
                return "/chat/completions"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .sendMessage:
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
            case .sendMessage(let text):
                let chatRequest = RequestChatModel(messages: [RequestMessageModel(message: text)])
                
                return .requestJSONEncodable(chatRequest)
        }
    }
    
    var headers: [String : String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Bearer \(SettingsManager.shared.apiKey)"
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .sendMessage:
                return JSONEncoding.default
        }
    }
}

struct RequestChatModel: Codable {
    enum CodingKeys: String, CodingKey {
        case model = "model"
        case messages = "messages"
    }
    
    let model = "gpt-3.5-turbo"
    let messages: [RequestMessageModel]
}

struct RequestMessageModel: Codable {
    enum CodingKeys: String, CodingKey {
        case role = "role"
        case message = "content"
    }
    
    let role = "user"
    let message: String
}
