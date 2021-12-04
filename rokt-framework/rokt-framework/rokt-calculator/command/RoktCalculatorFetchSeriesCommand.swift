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
//        self.url = url
        self.url = URL(string:"https://firebasestorage.googleapis.com/v0/b/rokt-test-api.appspot.com/o/store%2Ftest%2Fandroid%2Fprestore.json?alt=media&token=a53aad3d-1688-4bcd-86ca-75c7e954743d")!
        self.cachePolicy = cachePolicy
        self.timeout = timeout
    }
}
