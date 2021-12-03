//
//  RoktNetworkTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//

import XCTest
@testable import rokt_framework

fileprivate struct SuccessCommand: RoktCommand {
    var url: URL = URL(string: "\(RoktNetworkTests.testApiBaseUrl)/sampleJson")!
    var method: HttpMethod = .get
    var cachePolicy: RoktCachePolicy
    var timeout: TimeInterval? = nil
    var cacheKey: String { "SuccessCommand" }
}

fileprivate struct ServerErrorCommand: RoktCommand {
    var url: URL = URL(string: "\(RoktNetworkTests.testApiBaseUrl)/status500")!
    var method: HttpMethod = .get
    var cachePolicy: RoktCachePolicy
    var timeout: TimeInterval? = nil
    var cacheKey: String { "ServerErrorCommand" }
}

fileprivate struct ErrorDecodingCommand: RoktCommand {
    var url: URL = URL(string: "\(RoktNetworkTests.testApiBaseUrl)/sampleJson")!
    var method: HttpMethod = .get
    var cachePolicy: RoktCachePolicy
    var timeout: TimeInterval? = nil
    var cacheKey: String { "ErrorDecodingCommand" }
}

fileprivate struct EmptyDataCommand: RoktCommand {
    var url: URL = URL(string: "\(RoktNetworkTests.testApiBaseUrl)/emptyData")!
    var method: HttpMethod = .get
    var cachePolicy: RoktCachePolicy
    var timeout: TimeInterval? = nil
    var cacheKey: String { "EmptyDataCommand" }
}

fileprivate struct TimeoutTestCommand: RoktCommand {
    var url: URL = URL(string: "\(RoktNetworkTests.testApiBaseUrl)/timeout")!
    var method: HttpMethod = .get
    var cachePolicy: RoktCachePolicy
    var timeout: TimeInterval? = 1
    var cacheKey: String { "TimeoutTestCommand" }
}

class RoktNetworkTests: XCTestCase {
    static let testApiBaseUrl = "https://us-central1-rokt-test-api.cloudfunctions.net"

    let integrationTestTimeout = 30.0
    
    func testSuccessWithoutCache() {
        let roktNetwork = RoktNetwork(cache: RoktMockCache())
        let expection = XCTestExpectation(description: "RoktNetwork expect to retrieve json successfully")
        roktNetwork.execute(with: SuccessCommand(cachePolicy: .noCache)) { (result: Result<[String: String], RoktNetworkError>) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertTrue(response["say"] == "hello world")
                expection.fulfill()
            case .failure(_):
                XCTFail("RoktNetwork integration test with success case not working")
                XCTExpectFailure()
            }
        }
        
        wait(for: [expection], timeout: integrationTestTimeout)
    }
    
    func testServerError() {
        let roktNetwork = RoktNetwork(cache: RoktMockCache())
        let expection = XCTestExpectation(description: "RoktNetwork expect to retrieve server error")
        roktNetwork.execute(with: ServerErrorCommand(cachePolicy: .noCache)) { (result: Result<String?, RoktNetworkError>) in
            switch result {
            case .success(_):
                XCTFail("RoktNetwork integration test with error case not working")
                XCTExpectFailure()
            case .failure(let error):
                if case .httpError(let errorMessage, let statusCode) = error {
                    XCTAssertNotNil(errorMessage)
                    XCTAssertTrue(statusCode == 500)
                    expection.fulfill()
                } else {
                    XCTFail("Expected error in decoding data")
                    XCTExpectFailure()
                }
            }
        }
        
        wait(for: [expection], timeout: integrationTestTimeout)
    }
    
    func testEmptyDataError() {
        let roktNetwork = RoktNetwork(cache: RoktMockCache())
        let expection = XCTestExpectation(description: "RoktNetwork expect to retrieve empty data error")
        roktNetwork.execute(with: EmptyDataCommand(cachePolicy: .noCache)) { (result: Result<[String: String], RoktNetworkError>) in
            switch result {
            case .success(_):
                XCTFail("RoktNetwork integration test with error case not working")
                XCTExpectFailure()
            case .failure(let error):
                if case .errorDecodingData = error {
                    XCTAssertNotNil(error)
                    XCTAssertTrue(error.localizedDescription == "Error decoding data")
                    expection.fulfill()
                } else {
                    XCTFail("Expected error decoding data")
                    XCTExpectFailure()
                }
            }
        }
        
        wait(for: [expection], timeout: integrationTestTimeout)
    }
    
    func testNilDataError() {
        let command = EmptyDataCommand(cachePolicy: .noCache)
        let mockHttpURLResponse = HTTPURLResponse(url: command.url,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        let mockURLSession = RoktMockURLSession(data: nil,
                                                urlResponse: mockHttpURLResponse,
                                                error: nil)
        let roktNetwork = RoktNetwork(cache: RoktMockCache(), urlSession: mockURLSession)
        let expection = XCTestExpectation(description: "RoktNetwork expect to retrieve empty data error")
        roktNetwork.execute(with: command) { (result: Result<[String: String], RoktNetworkError>) in
            switch result {
            case .success(_):
                XCTFail("RoktNetwork integration test with error case not working")
                XCTExpectFailure()
            case .failure(let error):
                if case .emptyData = error {
                    XCTAssertNotNil(error)
                    XCTAssertNotNil(error.localizedDescription)
                    expection.fulfill()
                } else {
                    XCTFail("Expected empty data error")
                    XCTExpectFailure()
                }
            }
        }
        
        wait(for: [expection], timeout: integrationTestTimeout)
    }
    
    func testErrorDecodingData() {
        let roktNetwork = RoktNetwork(cache: RoktMockCache())
        let expection = XCTestExpectation(description: "RoktNetwork expect to retrieve json successfully")
        roktNetwork.execute(with: SuccessCommand(cachePolicy: .noCache)) { (result: Result<Bool, RoktNetworkError>) in
            switch result {
            case .success:
                XCTFail("RoktNetwork integration test with wrong decoding not working")
                XCTExpectFailure()
            case .failure(let error):
                if case .errorDecodingData = error {
                    XCTAssertNotNil(error)
                    XCTAssertNotNil(error.localizedDescription)
                    expection.fulfill()
                } else {
                    XCTFail("Expected error in decoding data")
                    XCTExpectFailure()
                }
            }
        }
        
        wait(for: [expection], timeout: integrationTestTimeout)
    }
    
    func testTimeout() {
        let roktNetwork = RoktNetwork(cache: RoktMockCache())
        let expection = XCTestExpectation(description: "RoktNetwork expect to retrieve json successfully")
        roktNetwork.execute(with: TimeoutTestCommand(cachePolicy: .noCache)) { (result: Result<[String: String], RoktNetworkError>) in
            switch result {
            case .success:
                XCTFail("RoktNetwork integration test with error case not working")
                XCTExpectFailure()
            case .failure(let error):
                if case .httpError(let errorMessage, let statusCode) = error {
                    XCTAssertNotNil(errorMessage)
                    XCTAssertTrue(errorMessage == "The request timed out.")
                    XCTAssertTrue(statusCode == 0)
                    expection.fulfill()
                } else {
                    XCTFail("RoktNetwork integration test with timeout error not working")
                    XCTExpectFailure()
                }
            }
        }
        
        wait(for: [expection], timeout: integrationTestTimeout)
    }
}
