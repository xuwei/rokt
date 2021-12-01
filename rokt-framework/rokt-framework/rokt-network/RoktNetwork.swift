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
    let policy: RoktCachePolicy
    let timeout: TimeInterval
    
    public init(policy: RoktCachePolicy = .cacheAndExpiresAfter(30.0 * TimeIntervalPeriod.minute), timeout: TimeInterval = 30) {
        self.policy = policy
        self.timeout = timeout
    }
}

final public class RoktNetwork {
    let configuration: RoktNetworkConfiguration
    let cache: RoktCache
    
    public init(with configuration: RoktNetworkConfiguration = .init(),
                cache: RoktCache = RoktDefaultsCache()) {
        self.configuration = configuration
        self.cache = cache
    }
    
    public func execute<T: Codable>(with command: RoktCommand, completion: @escaping (Result<T, RoktNetworkError>) -> Void) {
        if let cached = cache.retrieve(command.cacheKey, object: T.self) {
            completion(.success(cached))
        }
        
        let request = URLRequest(url: command.url,
                                 cachePolicy: .reloadIgnoringCacheData,
                                 timeoutInterval: command.timeout ?? configuration.timeout)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let err = error {
                let roktError: RoktNetworkError = .general(err)
                completion(.failure(roktError))
                return
            }
            
            do {
                guard let data = data else { completion(.failure(RoktNetworkError.emptyData)); return }
                let decoded = try JSONDecoder().decode(T.self, from: data)
                if let cachePolicy = command.cachePolicy {
                    let _ = self.cache.store(data: decoded, cachePolicy: cachePolicy, key: command.cacheKey)
                }
                completion(.success(decoded))
            } catch {
                completion(.failure(.errorDecodingData))
            }
        }
        
        dataTask.resume()
    }
}
