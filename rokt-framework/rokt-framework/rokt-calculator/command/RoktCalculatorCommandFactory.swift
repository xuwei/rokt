//
//  RoktCalculatorCommandFactory.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

final public class RoktCalculatorCommandFactory {
    public func makeRoktCalculatorFetchSeriesCommand(for baseURLString: String, cachePolicy: RoktCachePolicy? = nil, timeout: TimeInterval? = nil) -> RoktCalculatorFetchSeriesCommand? {
        guard !baseURLString.isEmpty, URL(string: baseURLString) != nil else { return nil }
        guard let url = URL(string: String("\(baseURLString)/store/test/android/prestored.json")) else { return nil }
        return RoktCalculatorFetchSeriesCommand(url: url, cachePolicy: cachePolicy ?? .neverExpires, timeout: timeout ?? 30.0)
    }
}
