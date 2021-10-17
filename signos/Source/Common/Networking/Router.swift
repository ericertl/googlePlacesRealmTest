//
//  Router.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation

enum Router {
    
    case getAddresses(input: String)
    
    var apiKey: String {
        return "" // YOUR_OWN_API_KEY
    }
    
    var scheme: String {
        switch self {
        case .getAddresses:
            return "https"
        }
    }

    var host: String {
        switch self {
        case .getAddresses:
            return "maps.googleapis.com"
        }
    }
    
    var path: String {
        switch self {
        case .getAddresses:
            return "/maps/api/place/findplacefromtext/json"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getAddresses(let input):
            return [
                URLQueryItem(name: "input", value: input),
                URLQueryItem(name: "inputtype", value: "textquery"),
                URLQueryItem(name: "fields", value: "place_id,formatted_address,name,photos,type"),
                URLQueryItem(name: "key", value: apiKey)
            ]
        }
    }
    
    var method: String {
        switch self {
        case .getAddresses:
            return "GET"
        }
    }
    
}
