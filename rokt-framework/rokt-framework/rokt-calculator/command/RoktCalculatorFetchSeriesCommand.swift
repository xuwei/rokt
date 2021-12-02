//
//  RoktCalculatorFetchSeriesCommand.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

final public class RoktCalculatorFetchSeriesCommand: RoktCommand {
    public var url: URL 
    public var method: HttpMethod = .get
    public var cachePolicy: RoktCachePolicy = .noCache
    public var timeout: TimeInterval? = nil
    public var cacheKey: String {
        let urlString = url.absoluteString
        return urlString
    }
    
    init(url: URL, cachePolicy: RoktCachePolicy = .noCache, timeout: TimeInterval? = RoktConstants.standardTimeout) {
        self.url = url
        self.cachePolicy = cachePolicy
        self.timeout = timeout
    }
}
