//
//  RoktSeriesResponseTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 4/12/21.
//

import XCTest
@testable import rokt_framework

class RoktSeriesResponseTests: XCTestCase {
    
    func testRoktSeriesResponseWithEmptySeries() {
        let response = RoktSeriesRespones(series: [])
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.series)
        XCTAssertTrue(response.series.count == 0)
        XCTAssertTrue(response.average == 0.0)
    }
    
    func testRoktSeriesResponseWithPositiveAndNegativeValuesInSeries() {
        let response = RoktSeriesRespones(series: [10.0, -300.0,-100.0, 400.0])
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.series)
        XCTAssertTrue(response.series.count == 4)
        XCTAssertTrue(response.average == 2.5)
    }
    
    func testRoktSeriesResponseWithPositiveInSeries() {
        let response = RoktSeriesRespones(series: [10.0, -300.0,-100.0, 400.0])
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.series)
        XCTAssertTrue(response.series.count == 4)
        XCTAssertTrue(response.average == 2.5)
    }
    
    func testRoktSeriesResponseWithShortSeries() {
        var series = [Double]()
        for i in 1...10 {
            series.append(Double(i))
        }
        
        let response = RoktSeriesRespones(series: series)
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.series)
        XCTAssertTrue(response.series.count == 10)
        XCTAssertTrue(response.sum == 55)
        XCTAssertTrue(response.average == 5.5)
    }
    
    func testRoktSeriesResponseWithLongSeries() {
        var series = [Double]()
        for i in 1...100000 {
            series.append(Double(i))
        }
        
        let response = RoktSeriesRespones(series: series)
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.series)
        XCTAssertTrue(response.series.count == 100000)
        XCTAssertTrue(response.sum == 5000050000)
        XCTAssertTrue(response.average == 50000.5)
    }
}
