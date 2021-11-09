//
//  AddressesViewModel.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation

struct AddressesViewModel {
    weak var dataSource: GenericDataSource<Address>?
    
    // MARK: - Work With Address
    
    func fetchAddresses() {
        self.dataSource?.data.value = DatabaseManager.shared.fetchAddresses()
    }
    
    func addAddress(address: Address) {
        DatabaseManager.shared.add(addresses: [address])
    }
    
    func isAddedAddress(address: Address) -> Bool {
        return DatabaseManager.shared.isAddedAddress(address)
    }
    
    func deleteAddress(place_id: String) {
        guard let address = getAddress(place_id: place_id) else {
            return
        }
        DatabaseManager.shared.delete(objects: [address])
    }
    
    func pinAddress(place_id: String) {
        guard let address = getAddress(place_id: place_id) else {
            return
        }
        DatabaseManager.shared.update(address: address)
    }
    
    private func getAddress(place_id: String) -> Address? {
        guard let addresses = dataSource?.data.value else {
            return nil
        }
        return addresses.first(where: { $0.placeId == place_id })
    }
}
