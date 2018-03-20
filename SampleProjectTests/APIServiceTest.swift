//
//  APIServiceTest.swift
//  SampleProjectTests
//
//  Created by Varun Varman on 02/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import XCTest
@testable import SampleProject
class APIServiceTest: XCTestCase {
    // MARK: dependencies and SUT
    var apiService: APIService!
    // MARK: setUp and tearDown
    override func setUp() {
        super.setUp()
        apiService = APIService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiService = nil
        super.tearDown()
    }
    func test_apiSerivce_operation() {
        // Check apiService for normal fuctioning where it's callback is populated with product's and no errors ; # of items equals 10.
        var itemCount = 10
        var eerror: Error!
        let promise = expectation(description: "handlerSuccess")
        apiService.fetchData { (products, error) in
            if let items = products {
                itemCount = items.count
                //
            } else if let err = error {
                eerror = err
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(10, itemCount, "The no. of products was inconsistant.")
        XCTAssertNil(eerror)
    }
}
