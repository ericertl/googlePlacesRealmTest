//
//  Address.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import RealmSwift

struct Addresses: Codable {
    let candidates: [Address]
    let status: String
    let errorMessage: String?
    let infoMessages: [String]?
}

final class Address: Object, Codable {
    @objc dynamic var isPinned = false
    @objc dynamic var placeId = ""
    @objc dynamic var name = ""
    @objc dynamic var formattedAddress = ""
    var photos = List<Photo>()
    var types = List<String>()
    
    //@objc dynamic var formatted_phone_number = "" // Google api returns error for this field
    
    override static func primaryKey() -> String? {
        return "placeId"
    }
    public convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        placeId = try container.decode(String.self, forKey: .placeId)
        name = try container.decode(String.self, forKey: .name)
        formattedAddress = try container.decode(String.self, forKey: .formattedAddress)
        photos = try container.decodeIfPresent(List<Photo>.self, forKey: .photos) ?? List<Photo>()
        types = try container.decodeIfPresent(List<String>.self, forKey: .types) ?? List<String>()
    }
}

//extension Address: Codable {}
