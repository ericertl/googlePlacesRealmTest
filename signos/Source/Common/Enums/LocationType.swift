//
//  LocationType.swift
//  signos
//
//  Created by Eric Ertl on 17/10/2021.
//

enum LocationType: String, CaseIterable {
    case all = "All"
    case gym = "Gym"
    case restaurant = "Restaurant"
    case supermarket = "Supermarket"
}

// MARK: -

extension LocationType: CustomStringConvertible {
    var description: String { rawValue }
}
