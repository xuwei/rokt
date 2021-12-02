//
//  RoktCacheProtocol.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 2/12/21.
//

import Foundation

public struct TimeIntervalPeriod {
    public static let minute: TimeInterval = 60
    public static let hour: TimeInterval = 3600
    public static let day: TimeInterval = 86400
}

public struct RoktCacheData: Codable {
    let cachedDate: Date
    let validUntil: Date?
    let data: Data
}

public enum RoktCachePolicy: Equatable {
    case noCache
    case cacheAndExpiresAfter(TimeInterval)
    case neverExpires
    
    public static func == (lhs: RoktCachePolicy, rhs: RoktCachePolicy) -> Bool {
        switch (lhs, rhs) {
        case (let .cacheAndExpiresAfter(l), let .cacheAndExpiresAfter(r)):
            return l == r
        case (.noCache, .noCache):
            return true
        case (.neverExpires, .neverExpires):
            return true
        default:
            return false
        }
    }
}

public protocol RoktCache {
    func store<T: Codable>(data: T, cachePolicy: RoktCachePolicy, key: String) -> Bool
    func retrieve<T: Codable>(_ key: String, object: T.Type) -> T?
    func clearCache()
}
