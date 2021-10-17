//
//  GoogleService.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation

final class GoogleService {
    weak var delegate: InternetConnectionProtocol?
}

// MARK: Public methods.
extension GoogleService {
    func getAddresses(input: String, completion: ((Result<[Address], Error>) -> ())? = nil) {
        if let internetConnection = delegate?.hasInternetConnection(), !internetConnection {
            completion?(.failure(NetworkLayerError.noInternetConnection))
            return
        }
        
        NetworkLayer.request(router: Router.getAddresses(input: input)) { (result: Result<Addresses, Error>) in
            switch result {
            case .success(let addresses):
                completion?(.success(addresses.candidates))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
