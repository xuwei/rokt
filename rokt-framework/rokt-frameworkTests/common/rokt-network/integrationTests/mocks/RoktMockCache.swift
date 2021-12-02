//
//  RoktMockCache.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 3/12/21.
//

import Foundation
@testable import rokt_framework

final public class RoktMockCache: RoktCache {
    public func store<T: Codable>(data: T, cachePolicy: RoktCachePolicy, key: String) -> Bool {
        return true
    }
    
    public func retrieve<T: Codable>(_ key: String, object: T.Type) -> T? {
        return nil
    }
    
    public func clearCache() {}
}
