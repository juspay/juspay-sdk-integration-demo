//
//  APIService.swift
//  juspay-sdk-integration-swift
//
//  Created by Sahil Sinha on 27/03/22.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    
    func fetchProcessSDKPayload() {
        var componentUrl = URLComponents()
        componentUrl.scheme = "https"
        componentUrl.host = "3d0d-2405-204-5404-9668-c086-49d6-6d75-c3a3.ngrok.io/"
        componentUrl.path = "create-session"
        
        
    }
    
}
