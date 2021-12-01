//
//  RoktCache.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 2/12/21.
//

import Foundation

final public class RoktDefaultsCache: RoktCache {
    let defaults: UserDefaults
    
    public init(with defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    public func store<T: Codable>(data: T, cachePolicy: RoktCachePolicy, key: String) -> Bool {
        guard cachePolicy != RoktCachePolicy.none else { return false }
        switch cachePolicy {
        case .none:
            return false
        case .cacheAndExpiresAfter(let timeInterval):
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(data) else { return false }
            let cacheData = RoktCacheData(cachedDate: Date(),
                                          validUntil: Date().addingTimeInterval(timeInterval),
                                          data: data)
            guard let encodedCacheData = try? encoder.encode(cacheData) else { return false }
            defaults.set(encodedCacheData, forKey: key)
            return true
        }
    }
    
    public func retrieve<T: Codable>(_ key: String, object: T.Type) -> T? {
        guard let encoded = defaults.object(forKey: key) as? Data else { return nil }
        let decoder = JSONDecoder()
        guard let decodedCacheData = try? decoder.decode(RoktCacheData.self, from: encoded) else { return nil }
        guard Date() < decodedCacheData.validUntil else { return nil }
        guard let decodedData = try? decoder.decode(T.self, from: decodedCacheData.data) else { return nil }
        return decodedData
    }
}
