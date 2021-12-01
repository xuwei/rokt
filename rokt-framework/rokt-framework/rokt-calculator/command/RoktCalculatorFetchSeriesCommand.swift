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
    public var cachePolicy: NSURLRequest.CachePolicy? = .useProtocolCachePolicy
    public var timeout: TimeInterval? = nil
    
    init(url: URL, cachePolicy: NSURLRequest.CachePolicy? = nil, timeout: TimeInterval? = nil) {
        self.url = url
        self.cachePolicy = cachePolicy
        self.timeout = timeout
    }
}
