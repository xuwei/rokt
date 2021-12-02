//
//  RoktCache.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 2/12/21.
//

import Foundation

final public class RoktDefaultsCache: RoktCache {
    public static let defaultSuiteName = "RoktDefaults"
    private let suiteName: String
    private let defaults: UserDefaults
    
    public init(with suiteName: String = RoktDefaultsCache.defaultSuiteName) {
        self.suiteName = suiteName
        self.defaults = UserDefaults(suiteName: self.suiteName)!
    }
    
    public func store<T: Codable>(data: T, cachePolicy: RoktCachePolicy, key: String) -> Bool {
        guard cachePolicy != RoktCachePolicy.noCache else { return false }
        switch cachePolicy {
        case .noCache:
            return false
        case .neverExpires:
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(data) else { return false }
            let cacheData = RoktCacheData(cachedDate: Date(),
                                          validUntil: nil,
                                          data: data)
            guard let encodedCacheData = try? encoder.encode(cacheData) else { return false }
            defaults.set(encodedCacheData, forKey: key)
            return true
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
        if let validUntil = decodedCacheData.validUntil, Date() > validUntil { return nil }
        guard let decodedData = try? decoder.decode(T.self, from: decodedCacheData.data) else { return nil }
        return decodedData
    }
    
    public func clearCache() {
        defaults.removeSuite(named: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }
}
