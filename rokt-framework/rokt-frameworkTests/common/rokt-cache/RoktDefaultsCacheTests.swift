//
//  RoktCacheTests.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 2/12/21.
//

import XCTest
@testable import rokt_framework

struct TestData: Codable {
    let dummyText: String
}

class RoktDefaultsCacheTests: XCTestCase {
    let suiteName = "Test"
    var roktCache: RoktCache!
    
    override func setUp() {
        roktCache = RoktDefaultsCache(with: suiteName)
    }
    
    override func tearDown() {
        roktCache.clearCache()
    }
    
    func testStoreWithNeverExpiresCachePolicy() {
        let key = "key"
        let data = TestData(dummyText: "hello")
        let stored = roktCache.store(data: data, cachePolicy: .neverExpires, key: key)
        XCTAssertTrue(stored)
        let retrieved = roktCache.retrieve(key, object: TestData.self)
        XCTAssertNotNil(retrieved)
        XCTAssertTrue(retrieved?.dummyText == "hello")
    }
    
    func testStoreWithNoCachePolicy() {
        let key = "key"
        let data = TestData(dummyText: "hello")
        let stored = roktCache.store(data: data, cachePolicy: .noCache, key: key)
        XCTAssertFalse(stored)
        let retrieved = roktCache.retrieve(key, object: TestData.self)
        XCTAssertNil(retrieved)
    }
    
    func testStoreWithCachePolicy() {
        let key = "key"
        let data = TestData(dummyText: "hello")
        let cachPolicy: RoktCachePolicy = .cacheAndExpiresAfter(3)
        let stored = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
        XCTAssertTrue(stored)
        if let storedData = roktCache.retrieve(key, object: TestData.self) {
            XCTAssertNotNil(storedData.dummyText)
            XCTAssertTrue(storedData.dummyText == "hello")
        } else {
            XCTFail("RoktDefaultsCache storing data failed")
        }
    }
    
    func testStoringArrayOfCodableWithCachePolicy() {
        let key = "key"
        let data: [TestData] = [TestData(dummyText: "hello"), TestData(dummyText: "world")]
        let cachPolicy: RoktCachePolicy = .cacheAndExpiresAfter(3)
        let stored = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
        XCTAssertTrue(stored)
        if let storedData = roktCache.retrieve(key, object: [TestData].self) {
            guard storedData.count == 2 else { XCTFail("stored array not handle properly"); return }
            XCTAssertNotNil(storedData[0].dummyText)
            XCTAssertTrue(storedData[0].dummyText == "hello")
            XCTAssertNotNil(storedData[1].dummyText)
            XCTAssertTrue(storedData[1].dummyText == "world")
        } else {
            XCTFail("RoktDefaultsCache storing data failed")
        }
    }
    
    func testStoringMapOfCodableWithCachePolicy() {
        let key = "key"
        let data: [String: TestData] = ["1": TestData(dummyText: "hello")]
        let cachPolicy: RoktCachePolicy = .cacheAndExpiresAfter(3)
        let stored = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
        XCTAssertTrue(stored)
        if let storedData = roktCache.retrieve(key, object: [String: TestData].self) {
            guard storedData.count == 1 else { XCTFail("stored map not handle properly"); return }
            guard let testData = storedData["1"] else { XCTFail("stored map not handle properly"); return }
            XCTAssertTrue(testData.dummyText == "hello")
        } else {
            XCTFail("RoktDefaultsCache storing data failed")
        }
    }
    
    func testExpiredStorageWithCachePolicy() {
        let expectation = XCTestExpectation(description: "cache data should expired")
        let expiryTime: TimeInterval = 1
        let key = "key"
        let data = TestData(dummyText: "hello")
        let cachPolicy: RoktCachePolicy = .cacheAndExpiresAfter(expiryTime)
        let stored = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
        XCTAssertTrue(stored)
        XCTAssertNotNil(roktCache.retrieve(key, object: TestData.self))
        DispatchQueue.main.asyncAfter(deadline: .now() + expiryTime + 0.1, execute: { [weak self] in
            XCTAssertNil(self?.roktCache.retrieve(key, object: TestData.self), "cache data didn't expired after expiry time")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)

    }
    
    func testRetrieveAfterClearCache() {
        let key = "key"
        let data = TestData(dummyText: "hello")
        let cachPolicy: RoktCachePolicy = .cacheAndExpiresAfter(3)
        let stored = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
        XCTAssertTrue(stored)
        if let storedData = roktCache.retrieve(key, object: TestData.self) {
            XCTAssertNotNil(storedData.dummyText)
            XCTAssertTrue(storedData.dummyText == "hello")
            roktCache.clearCache()
            XCTAssertNil(roktCache.retrieve(key, object: TestData.self))
        } else {
            XCTFail("RoktDefaultsCache storing data failed")
        }
    }
    
    func testStoreAfterClearCache() {
        let key = "key"
        let data = TestData(dummyText: "hello")
        let cachPolicy: RoktCachePolicy = .cacheAndExpiresAfter(3)
        let stored = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
        XCTAssertTrue(stored)
        if let storedData = roktCache.retrieve(key, object: TestData.self) {
            XCTAssertNotNil(storedData.dummyText)
            XCTAssertTrue(storedData.dummyText == "hello")
            roktCache.clearCache()
            let _ = roktCache.store(data: data, cachePolicy: cachPolicy, key: key)
            XCTAssertNotNil(roktCache.retrieve(key, object: TestData.self))
            XCTAssertTrue(storedData.dummyText == "hello")
        } else {
            XCTFail("RoktDefaultsCache storing data failed")
        }
    }
}
