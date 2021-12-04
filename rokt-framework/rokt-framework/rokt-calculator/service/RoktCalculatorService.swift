//
//  Calculator.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

public protocol RoktService {
    var baseURLString: String { get }
}

final public class RoktCalculatorService: RoktService {
    public var baseURLString: String
    private let roktNetwork: RoktNetwork
    
    public init(baseURLString: String) {
        self.baseURLString = baseURLString
        self.roktNetwork = RoktNetwork()
    }
    
    public func removeNumberFromSeries(_ valueToRemove: Double, for command: RoktCalculatorFetchSeriesCommand) -> Bool {
        guard var series = self.roktNetwork.cache.retrieve(command.cacheKey, object: [Double].self) else { return false }
        series = series.filter { $0 != valueToRemove }
        return self.roktNetwork.cache.store(data: series, cachePolicy: command.cachePolicy, key: command.cacheKey)
    }
    
    public func addToSeries(_ newValue: Double, for command: RoktCalculatorFetchSeriesCommand) -> Bool {
        guard var series = self.roktNetwork.cache.retrieve(command.cacheKey, object: [Double].self) else { return false }
        series.append(newValue)
        return self.roktNetwork.cache.store(data: series, cachePolicy: command.cachePolicy, key: command.cacheKey)
    }
    
    public func fetchSeries(with command: RoktCalculatorFetchSeriesCommand, _ completion: @escaping (Result<RoktSeriesResponse, RoktNetworkError>) -> Void) {
        roktNetwork.execute(with: command) { (result: Result<[Double], RoktNetworkError>) in
            switch result {
            case .success(let series):
                let response = RoktSeriesResponse(series: series)
                completion(.success(response))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
