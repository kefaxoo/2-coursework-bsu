//
//  OpenAiProvider.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import Foundation
import Moya
import Moya_ObjectMapper

final class OpenAiProvider {
    static let shared = OpenAiProvider()
    
    private init() {}
    
    private let provider = MoyaProvider<OpenAiApi>(plugins: [NetworkLoggerPlugin()])
    
    func sendMessage(message: String, success: @escaping ((MessageModel) -> ()), failure: @escaping ((String) -> ())) {
        provider.request(.sendMessage(text: message)) { result in
            switch result {
                case .success(let response):
                    guard let result = try? response.mapObject(MessageModel.self) else {
                        failure("Map object error")
                        return
                    }
                    
                    success(result)
                case .failure(let error):
                    guard let description = error.errorDescription else { return }
                    
                    failure(description)
            }
        }
    }
}
