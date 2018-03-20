//
//  ProductListViewModelTest.swift
//  SampleProjectTests
//
//  Created by Varun Varman on 02/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import XCTest
@testable import SampleProject
class ProductListViewModelTest: XCTestCase {
    // MARK: dependencies and SUT
    var viewModelSUT: ProductListViewModel!
    var apiService: MockAPIService!
    // MARK: setUp and tearDown
    override func setUp() {
        super.setUp()
        apiService = MockAPIService()
        viewModelSUT = ProductListViewModel(service: apiService)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        viewModelSUT = nil
        apiService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testViewModelAlertMessageForError() {
        // test to check if the viewModel alert message are updated properly, based on the callback from the APIService
        viewModelSUT.getData()
        apiService.callbackWith(Error: .dataIncompatible)
        guard let alertMessage = viewModelSUT.alertMessage else {
            XCTFail("No Alert message set on calling of closure")
            return
        }
        XCTAssertEqual(alertMessage, APIServiceError.dataIncompatible.rawValue, "The error message and the alert view message are not same.")
    }
    func testViewModelForUnexpectedError() {
        viewModelSUT.getData()
        apiService.unexpectedCallback()
        guard let alertMessage = viewModelSUT.alertMessage else {
            XCTFail("No alert message found")
            return
        }
        XCTAssertEqual(alertMessage, Constants.AlertMessages.unknownError, "Alert message not similar to one specified for unknown errors.")
    }
    func testViewModelCountForProducts() {
        viewModelSUT.getData()
        apiService.succeed()
        XCTAssertEqual(viewModelSUT.numberOfProducts(), MockProductGenerator().generateMocks().count, "No. of cellViewModel not equal to the number of products.")
    }
}
// MARK: Helper Methods
class MockAPIService: APIServiceProtocol {
    private (set) var localCompleTionHandler: (([Product]?, APIServiceError?) -> Void)!
    func fetchData(_ completionHandler: @escaping ([Product]?, APIServiceError?) -> Void) {
        localCompleTionHandler = completionHandler
    }
    func succeed() {
        localCompleTionHandler(MockProductGenerator().generateMocks(), nil)
    }
    func callbackWith(Error error: APIServiceError) {
        localCompleTionHandler(nil, error)
    }
    func unexpectedCallback() {
        localCompleTionHandler(nil, nil)
    }
}
class MockProductGenerator {
    func generateMocks() -> [Product] {
        var products: [Product] = [Product]()
        for i in 1...5 {
            products.append( Product(productName: "Name\(i)", productPrice: i) )
        }
        return products
    }
}
