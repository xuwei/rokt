//
//  RoktCalculatorServiceTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//
import Foundation
import XCTest
import rokt_framework

fileprivate class RoktPopulatedMockCache: RoktCache {
    var series: [Double] = [100.0, 50.0, -100.0]
    
    func store<T: Codable>(data: T, cachePolicy: RoktCachePolicy, key: String) -> Bool {
        guard let series = data as? [Double] else { return false }
        self.series = series
        return true
    }
    
    func retrieve<T>(_ key: String, object: T.Type) -> T? where T : Decodable, T : Encodable {
        return series as? T
    }
    
    func clearCache() {}
}
fileprivate class RoktMockNetwork: RoktNetworkProtocol {
    var configuration: RoktNetworkConfiguration = RoktNetworkConfiguration(policy: .noCache, timeout: 0)
    var cache: RoktCache = RoktPopulatedMockCache()
    var urlSession: URLSession = URLSession(configuration: .default)
    func execute<T: Codable>(with command: RoktCommand,
                             forcedRefresh: Bool,
                             completion: @escaping (Result<T, RoktNetworkError>) -> Void) {
        completion(.failure(.emptyData))
    }
}

class RoktCalculatorServiceTests: XCTestCase {
    let service: RoktCalculatorService = RoktCalculatorService(baseURLString: "https://firebasestorage.googleapis.com")
    lazy var factory = RoktCalculatorCommandFactory(for: self.service)
    let sampleJsonUrl = "https://firebasestorage.googleapis.com/v0/b/rokt-test-api.appspot.com/o/store%2Ftest%2Fandroid%2Fsimple-prestored.json?alt=media&token=358a760c-9860-4583-b2ea-6eeccddc5cd7"
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testFetchSeries() {
        let expectation = XCTestExpectation(description: "RoktCalculatorService executing fetchSeries should return data")
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .noCache, customURL: URL(string: sampleJsonUrl)) else {
            XCTFail("Unable to create command")
            return
        }
        service.fetchSeries(with: command) { (result: Result<RoktSeriesResponse, RoktNetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertTrue(response.series.count == 4)
                XCTAssertTrue(response.sum == 10.0)
                XCTAssertTrue(response.average == 2.5)
                expectation.fulfill()
            case .failure:
                XCTExpectFailure("failed to fetch series")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchSeriesWithError() {
        let expectation = XCTestExpectation(description: "RoktCalculatorService executing fetchSeries should return data")
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .noCache, customURL: URL(string: "test.com")) else {
            XCTFail("Unable to create command")
            return
        }
        service.fetchSeries(with: command) { (result: Result<RoktSeriesResponse, RoktNetworkError>) in
            switch result {
            case .success:
                XCTExpectFailure("failed to fetch series")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRemoveNumberFromSeriesSuccessful() {
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .noCache, customURL: URL(string: sampleJsonUrl)) else {
            XCTFail("Unable to create command")
            return
        }
        let service = RoktCalculatorService(baseURLString: "", customRoktNetwork: RoktMockNetwork())
        let stored = service.addToSeries(-999, for: command)
        XCTAssertTrue(stored)
        XCTAssertTrue(service.removeNumberFromSeries(-999, for: command))
    }
    
    func testRemoveNumberFromSeriesFailed() {
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .noCache, customURL: URL(string: sampleJsonUrl)) else {
            XCTFail("Unable to create command")
            return
        }
        let service = RoktCalculatorService(baseURLString: "", customRoktNetwork: RoktMockNetwork())
        let stored = service.addToSeries(-100, for: command)
        XCTAssertFalse(stored)
    }
    
    func testRemoveNumberFromSeriesUntilEmpty() {
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .noCache, customURL: URL(string: sampleJsonUrl)) else {
            XCTFail("Unable to create command")
            return
        }
        let service = RoktCalculatorService(baseURLString: "", customRoktNetwork: RoktMockNetwork())
        XCTAssertTrue(service.removeNumberFromSeries(-100, for: command))
        XCTAssertTrue(service.removeNumberFromSeries(50, for: command))
        XCTAssertTrue(service.removeNumberFromSeries(100, for: command))
        XCTAssertFalse(service.removeNumberFromSeries(100, for: command))
        let stored2 = service.addToSeries(-100, for: command)
        XCTAssertTrue(stored2)
    }
}
