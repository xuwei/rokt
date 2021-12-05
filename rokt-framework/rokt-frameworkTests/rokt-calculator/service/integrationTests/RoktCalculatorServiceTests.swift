//
//  RoktCalculatorServiceTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//

import XCTest
import rokt_framework

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
        
    }
    
    func testRemoveNumberFromSeriesFailed() {
        
    }
    
    func testAddToSeriesSuccessful() {
        
    }
    
    func testAddToSeriesFailed() {
        
    }
}
