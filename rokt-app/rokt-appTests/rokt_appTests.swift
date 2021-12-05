//
//  rokt_appTests.swift
//  rokt-appTests
//
//  Created by Xuwei Liang on 1/12/21.
//

import XCTest
@testable import rokt_app

class CalculatorFormValidatorTests: XCTestCase {
    let validator = CalculatorFormValidator()
    
    func testValidInput() {
        let test1 = "0.000001"
        let test2 = "10.11111"
        let test3 = "10"
        let test4 = "0"
        let test5 = "-1.11111"
        let test6 = "-10"
        
        let arr = [test1, test2, test3, test4, test5, test6]
        arr.forEach {
            XCTAssertNil(validator.isValidInput($0))
        }
    }
    
    func testInvalidInput() {
        let test1 = "a"
        let test2 = "$10.11111"
        let test3 = "@10"
        let test4 = "1000,000"
        let test5 = "-1.11111.1"
        let test6 = "160.1.1"
        let test7 = ""
        let test8 = "11111111111111111111111"
        
        let arr = [test1, test2, test3, test4, test5, test6, test7, test8]
        arr.forEach {
            XCTAssertNotNil(validator.isValidInput($0))
        }
    }
}
