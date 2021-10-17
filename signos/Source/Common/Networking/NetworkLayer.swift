//
//  NetworkLayer.swift
//  signos
//
//  Created by Eric Ertl on 16/10/2021.
//

import Foundation

protocol InternetConnectionProtocol: NSObjectProtocol {
    func hasInternetConnection() -> Bool
}

enum NetworkLayerError: Error {
    case url
    case dataTask
    case data
    case response
    case statusCode(status: Int, message: String)
    case noInternetConnection
}

extension NetworkLayerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .statusCode(status: _, message: let message):
            return message
        default:
            return "Something went wrong."
        }
    }
}

extension NetworkLayerError: CustomNSError {
    public static var errorDomain: String {
        return "com.eertl.signos"
    }
    
    public var errorCode: Int {
        switch self {
        case .statusCode(status: let status, message: _):
            return status
        default:
            return 0
        }
    }
    
    public var errorUserInfo: [String : Any] {
        if let errorDescription = errorDescription {
            return ["message": errorDescription]
        }
        return [:]
    }
}

struct NetworkLayer {
    static func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters

        guard let url = components.url else {
            completion(.failure(NetworkLayerError.url))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method

        let session = URLSession(configuration: .default)
        
        #if DEBUG
        print("\nHTTP request: \(urlRequest.url?.absoluteString ?? "")\n")
        #endif

        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error ?? NetworkLayerError.dataTask))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkLayerError.data))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkLayerError.response))
                return
            }
            #if DEBUG
            print("\nHTTP response: \(response.url?.absoluteString ?? "")\nParams: \(data.prettyPrintedJSONString ?? "")\n")
            #endif
            guard (200...299).contains(response.statusCode) else {
                var message = ""
                do {
                    let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    if let responseMessage = responseData?["message"] as? String {
                        message = responseMessage
                    }
                } catch let error as NSError {
                    print(error)
                }
                completion(.failure(NetworkLayerError.statusCode(status: response.statusCode, message: message)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch let error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }

        dataTask.resume()
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
