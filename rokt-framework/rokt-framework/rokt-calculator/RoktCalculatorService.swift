//
//  Calculator.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

public protocol RoktCalculatorServiceProtocol {
    func fetchSeries(with command: RoktCalculatorFetchSeriesCommand, _ completion: @escaping (Result<[Double], RoktNetworkError>) -> Void)
}

final public class RoktCalculatorService {
    public let baseURLString: String
    private let roktNetwork: RoktNetwork
    
    public init(baseURLString: String) {
        self.baseURLString = baseURLString
        self.roktNetwork = RoktNetwork()
    }
    
    public func fetchSeries(with command: RoktCalculatorFetchSeriesCommand, _ completion: @escaping (Result<[Double], RoktNetworkError>) -> Void) {
        roktNetwork.execute(with: command) { result in
            completion(result)
        }
    }
}
