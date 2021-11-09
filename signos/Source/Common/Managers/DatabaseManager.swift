//
//  DatabaseManager.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Work With Objects
    
    func delete(objects: [Object]) {
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func update(address: Address) {
        try! realm.write {
            address.isPinned = !address.isPinned
            realm.add(address, update: .all)
        }
    }
    
    // MARK: - Work With Addresses
    
    func add(addresses: [Address]) {
        let objects = addresses.map { Address(value: $0) }
        
        try! realm.write {
            realm.add(objects)
        }
    }
    
    func replace(addresses: [Address]) {
        let existingAddresses = self.fetchAddresses()
        let addressesToAdd = addresses.filter { !existingAddresses.contains($0) }
        let addressesToDelete = existingAddresses.filter { !addresses.contains($0) }

        try! realm.write {
            realm.add(addressesToAdd)
            realm.delete(addressesToDelete)
        }
    }
    
    func fetchAddresses() -> [Address] {
        return Array(realm.objects(Address.self).sorted(byKeyPath: "isPinned", ascending: false))
    }
    
    func isAddedAddress(_ address: Address) -> Bool {
        let addresses = realm.objects(Address.self).filter("id == \(address.placeId)")
        return !addresses.isEmpty
    }
}
