//
//  RoktMockURLSession.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 3/12/21.
//

import Foundation
@testable import rokt_framework

final class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let mockError: Error?
    
    // since error is read only, this is to get around read only variable
    override var error: Error? {
        return mockError
    }

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)!

    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.mockError = error
    }

    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler(self.data, self.urlResponse, self.error)
        }
    }
}

final class RoktMockURLSession: URLSession {
    let mockTask: MockTask
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockTask = MockTask(data: data, urlResponse: urlResponse, error:
            error)
    }
    
    override func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}
