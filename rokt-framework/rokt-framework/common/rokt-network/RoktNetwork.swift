//
//  RoktNetwork.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

public enum RoktNetworkError: Error, Equatable {
    case httpError(String?, Int)
    case genericError
    case emptyData
    case errorDecodingData
    
    public static func == (lhs: RoktNetworkError, rhs: RoktNetworkError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}

extension RoktNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .httpError(let errorMessage, let statusCode):
            return errorMessage ?? NSLocalizedString("Status code \(statusCode)", comment: "")
        case .genericError:
            return NSLocalizedString("Some error has occurred", comment: "")
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
    
    public init(policy: RoktCachePolicy = .cacheAndExpiresAfter(30.0 * TimeIntervalPeriod.minute), timeout: TimeInterval = RoktConstants.standardTimeout) {
        self.policy = policy
        self.timeout = timeout
    }
}

public protocol RoktNetworkProtocol {
    var configuration: RoktNetworkConfiguration { get }
    var cache: RoktCache { get }
    var urlSession: URLSession { get }
    func execute<T: Codable>(with command: RoktCommand,
                             forcedRefresh: Bool,
                             completion: @escaping (Result<T, RoktNetworkError>) -> Void)
}

final public class RoktNetwork: RoktNetworkProtocol {
    public var configuration: RoktNetworkConfiguration
    public var cache: RoktCache
    public var urlSession: URLSession
    
    public init(with configuration: RoktNetworkConfiguration = .init(),
                cache: RoktCache = RoktDefaultsCache(),
                urlSession: URLSession = .shared) {
        self.configuration = configuration
        self.cache = cache
        self.urlSession = urlSession
    }
    
    public func execute<T: Codable>(with command: RoktCommand,
                                    forcedRefresh: Bool = false,
                                    completion: @escaping (Result<T, RoktNetworkError>) -> Void) {
        if forcedRefresh == false, let cached = cache.retrieve(command.cacheKey, object: T.self) {
            completion(.success(cached)); return 
        }
        
        let request = URLRequest(url: command.url,
                                 cachePolicy: .reloadIgnoringCacheData,
                                 timeoutInterval: command.timeout ?? configuration.timeout)
        let dataTask = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { completion(.failure(.genericError)); return }

            if let err = error {
                let httpResponse: HTTPURLResponse? = response as? HTTPURLResponse
                let roktError: RoktNetworkError = .httpError(err.localizedDescription, httpResponse?.statusCode ?? 0)
                completion(.failure(roktError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { completion(.failure(.genericError)); return }
            guard let data = data else { completion(.failure(RoktNetworkError.emptyData)); return }
            if httpResponse.statusCode != 200 {
                let errorMessage = String(decoding: data, as: UTF8.self)
                completion(.failure(.httpError(errorMessage, httpResponse.statusCode)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                if command.cachePolicy != .noCache {
                    let _ = self.cache.store(data: decoded, cachePolicy: command.cachePolicy, key: command.cacheKey)
                }
                completion(.success(decoded))
            } catch {
                completion(.failure(.errorDecodingData))
            }
        }
        
        dataTask.resume()
    }
}
