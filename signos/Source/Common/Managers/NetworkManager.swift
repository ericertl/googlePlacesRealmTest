//
//  NetworkManager.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation

final class NetworkManager: NSObject {
    let googleService: GoogleService = GoogleService()
    private var reachability: Reachability?
    private var hasInternet: Bool = true

    public override init() {
        super.init()
        addReachabilityObserver()
        googleService.delegate = self
    }

    deinit {
        removeReachabilityObserver()
    }
}

// MARK: Reachability
private extension NetworkManager {
    func reachabilityChanged(_ isReachable: Bool) {
        hasInternet = isReachable
    }

    func addReachabilityObserver() {
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to add reachability observer")
        }

        reachability?.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(true)
        }

        reachability?.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(false)
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    func removeReachabilityObserver() {
        reachability?.stopNotifier()
        reachability = nil
    }
}

// MARK: InternetConnectionProtocol
extension NetworkManager: InternetConnectionProtocol {
    func hasInternetConnection() -> Bool {
        return hasInternet
    }
}
