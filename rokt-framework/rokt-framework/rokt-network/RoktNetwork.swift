//
//  RoktNetwork.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

public enum RoktNetworkError: Error {
    case general(Error)
    case emptyData
    case errorDecodingData
}

extension RoktNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .general(let err):
            return err.localizedDescription
        case .emptyData:
            return NSLocalizedString("Data returned as nil", comment: "")
        case .errorDecodingData:
            return NSLocalizedString("Error decoding data", comment: "")
        }
    }
}

final public class RoktNetworkConfiguration {
    let policy: URLRequest.CachePolicy
    let timeout: TimeInterval
    
    public init(policy: URLRequest.CachePolicy = .reloadRevalidatingCacheData, timeout: TimeInterval = 30.0) {
        self.policy = policy
        self.timeout = timeout
    }
}

final public class RoktNetwork {
    let configuration: RoktNetworkConfiguration
    
    public init(_ configuration: RoktNetworkConfiguration = .init()) {
        self.configuration = configuration
    }
    
    public func execute<T: Decodable>(with command: RoktCommand, completion: @escaping (Result<T, RoktNetworkError>) -> Void) {
        let request = URLRequest(url: command.url,
                                 cachePolicy: command.cachePolicy ?? configuration.policy ,
                                 timeoutInterval: command.timeout ?? configuration.timeout)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                let roktError: RoktNetworkError = .general(err)
                completion(.failure(roktError))
                return
            }
            
            do {
                guard let data = data else { completion(.failure(RoktNetworkError.emptyData)); return }
                let decodable = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodable))
            } catch {
                completion(.failure(.errorDecodingData))
            }
        }
    
        dataTask.resume()
    }
}
