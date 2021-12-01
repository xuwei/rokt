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
    public var cachePolicy: RoktCachePolicy? = .cacheAndExpiresAfter(60 * TimeIntervalPeriod.minute)
    public var timeout: TimeInterval? = nil
    public var cacheKey: String {
        let urlString = url.absoluteString
        return urlString
    }
    
    init(url: URL, cachePolicy: RoktCachePolicy? = nil, timeout: TimeInterval? = 20.0) {
        self.url = url
        self.cachePolicy = cachePolicy
        self.timeout = timeout
    }
}
