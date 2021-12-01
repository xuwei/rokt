//
//  Command.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol RoktCommand {
    var url: URL { get }
    var method: HttpMethod { get }
    var cachePolicy: RoktCachePolicy? { get }
    var timeout: TimeInterval? { get }
    var cacheKey: String { get }
}
