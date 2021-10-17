//
//  Photo.swift
//  signos
//
//  Created by Eric Ertl on 17/10/2021.
//

import RealmSwift

final class Photo: Object {
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var photoReference = ""
}

extension Photo: Codable {}
