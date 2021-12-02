//
//  RoktCalculatorCommandFactoryTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//

import XCTest
@testable import rokt_framework

class RoktCalculatorCommandFactoryTests: XCTestCase {
    let factory = RoktCalculatorCommandFactory()
    
    func testMakeRoktCalculatorFetchSeriesCommandWithValidBaseURLString() {
        let command = factory.makeRoktCalculatorFetchSeriesCommand(for: "test.com")
        XCTAssertNotNil(command)
        XCTAssertTrue(command?.url.absoluteString == "test.com/store/test/android/prestored.json")
    }
    
    func testMakeRoktCalculatorFetchSeriesCommandWithInvalidBaseURLString() {
        let command = factory.makeRoktCalculatorFetchSeriesCommand(for: "")
        XCTAssertNil(command, "Should not create command with invalid baseURLString")
    }
}
