//
//  SearchViewModel.swift
//  signos
//
//  Created by Eric Ertl on 17/10/2021.
//

import Foundation

struct SearchViewModel {
    weak var dataSource: GenericDataSource<Address>?
    private let networkManager: NetworkManager = NetworkManager()
    
    var onErrorHandling: ((Error?) -> Void)?
    
    // MARK: - Work With Address
    
    func fetchAddresses(input: String, type: String?) {
        networkManager.googleService.getAddresses(input: input, completion: { (result: Result<[Address], Error>) in
            switch result {
            case .success(let addresses):
                if let type = type,
                   let locationType = LocationType(rawValue: type),
                   locationType != LocationType.all {
                    let filteredAddresses = addresses.filter { (address: Address) -> Bool in
                        return address.types.contains(type.lowercased())
                    }
                    self.dataSource?.data.value = filteredAddresses
                } else {
                    self.dataSource?.data.value = addresses
                }
            case .failure(let error):
                self.onErrorHandling?(error)
            }
        })
    }
    
    func clearDataSource() {
        self.dataSource?.data.value = []
    }
}
