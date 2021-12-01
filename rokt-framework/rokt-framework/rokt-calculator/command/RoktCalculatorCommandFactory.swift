//
//  RoktCalculatorCommandFactory.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

final public class RoktCalculatorCommandFactory {
    public static func makeRoktCalculatorFetchSeriesCommand(for service: RoktCalculatorService) -> RoktCalculatorFetchSeriesCommand? {
        guard let url = URL(string: String("\(service.baseURLString)/store/test/android/prestored.json")) else { return nil }
        return RoktCalculatorFetchSeriesCommand(url: url)
    }
}
