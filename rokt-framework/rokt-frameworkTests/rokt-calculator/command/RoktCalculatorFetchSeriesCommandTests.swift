//
//  RoktCalculatorFetchSeriesCommandTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//

import XCTest
@testable import rokt_framework

class RoktCalculatorFetchSeriesCommandTests: XCTestCase {
    let factory = RoktCalculatorCommandFactory(for: RoktMockService(with: "test.com"))
    
    func testRoktCalculatorFetchSeriesCommandWithoutConfiguration() {
        let expectedKey = "test.com/store/test/android/prestored.json"
        let command = factory.makeRoktCalculatorFetchSeriesCommand()
        guard let command = command else { return XCTFail("RoktCalculatorFetchSeriesComman should not be nil") }
        XCTAssertTrue(command.timeout == RoktConstants.standardTimeout)
        XCTAssertTrue(command.cachePolicy == .neverExpires)
        XCTAssertNotNil(command.url)
        XCTAssertTrue(command.url.absoluteString == "test.com/store/test/android/prestored.json")
        XCTAssertTrue(command.method == .get)
        XCTAssertTrue(command.cacheKey == expectedKey)
    }
    
    func testRoktCalculatorFetchSeriesCommandWithConfiguration() {
        let expectedKey = "test.com/store/test/android/prestored.json"
        let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .cacheAndExpiresAfter(30.0), timeout: 10.0)
        guard let command = command else { return XCTFail("RoktCalculatorFetchSeriesComman should not be nil") }
        XCTAssertTrue(command.timeout == 10.0)
        XCTAssertFalse(command.cachePolicy == .cacheAndExpiresAfter(1))
        XCTAssertTrue(command.cachePolicy == .cacheAndExpiresAfter(30.0))
        XCTAssertNotNil(command.url)
        XCTAssertTrue(command.url.absoluteString == "test.com/store/test/android/prestored.json")
        XCTAssertTrue(command.method == .get)
        XCTAssertTrue(command.cacheKey == expectedKey)
    }
    
    func testRoktCalculatorFetchSeriesCommandWithConfigurationNoCaching() {
        let expectedKey = "test.com/store/test/android/prestored.json"
        let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .noCache, timeout: 10.0)
        guard let command = command else { return XCTFail("RoktCalculatorFetchSeriesComman should not be nil") }
        XCTAssertTrue(command.timeout == 10.0)
        XCTAssertTrue(command.cachePolicy == .noCache)
        XCTAssertNotNil(command.url)
        XCTAssertTrue(command.url.absoluteString == "test.com/store/test/android/prestored.json")
        XCTAssertTrue(command.method == .get)
        XCTAssertTrue(command.cacheKey == expectedKey)
    }
}
