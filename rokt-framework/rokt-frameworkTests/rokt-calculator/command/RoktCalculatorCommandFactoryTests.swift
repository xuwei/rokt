//
//  RoktCalculatorCommandFactoryTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//

import XCTest
@testable import rokt_framework

class RoktCalculatorCommandFactoryTests: XCTestCase {
    
    
    func testMakeRoktCalculatorFetchSeriesCommandWithValidBaseURLString() {
        let factory = RoktCalculatorCommandFactory(for: RoktMockService(with: "test.com"))
        let command = factory.makeRoktCalculatorFetchSeriesCommand()
        XCTAssertNotNil(command)
        XCTAssertTrue(command?.url.absoluteString == "test.com/store/test/android/prestored.json")
    }
    
    func testMakeRoktCalculatorFetchSeriesCommandWithInvalidBaseURLString() {
        let factory = RoktCalculatorCommandFactory(for: RoktMockService(with: ""))
        let command = factory.makeRoktCalculatorFetchSeriesCommand()
        XCTAssertNil(command, "Should not create command with invalid baseURLString")
    }
}
