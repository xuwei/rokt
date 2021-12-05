//
//  RoktCalculatorCommandFactory.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

final public class RoktCalculatorCommandFactory {
    let baseURLString: String
    
    public init(for service: RoktService) {
        baseURLString = service.baseURLString
    }
    
    public func makeRoktCalculatorFetchSeriesCommand(with cachePolicy: RoktCachePolicy? = nil, timeout: TimeInterval? = nil, customURL: URL? = nil) -> RoktCalculatorFetchSeriesCommand? {
        guard !baseURLString.isEmpty, URL(string: baseURLString) != nil else { return nil }
        guard let url = customURL ?? URL(string: String("\(baseURLString)/store/test/android/prestored.json")) else { return nil }
        return RoktCalculatorFetchSeriesCommand(url: url, cachePolicy: cachePolicy ?? .neverExpires, timeout: timeout ?? RoktCommandConstants.defaultTimeout)
    }
}
