//
//  Command.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
}

public protocol RoktCommand {
    var url: URL { get }
    var method: HttpMethod { get }
    var cachePolicy: NSURLRequest.CachePolicy? { get }
    var timeout: TimeInterval? { get }
}
