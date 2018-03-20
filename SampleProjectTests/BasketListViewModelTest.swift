//
//  BasketListViewModelTest.swift
//  SampleProjectTests
//
//  Created by Varun Varman on 02/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import XCTest
@testable import SampleProject
class BasketListViewModelTest: XCTestCase {
    // MARK: dependencies and SUT
    var viewModelSUT: CheckoutBasketListViewModel!
    var singleton: CheckoutBasket!
    // MARK: setUp and tearDown
    override func setUp() {
        super.setUp()
        viewModelSUT = CheckoutBasketListViewModel()
        singleton = CheckoutBasket.sharedInstance
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModelSUT = nil
        singleton.removeAllProducts()
        singleton = nil
        super.tearDown()
    }
    // Note: CVM = cvm, abbrevation for cellViewModel, in this context it's CheckoutBasketProductCellViewModel a ViewModel
    func test_ProductsInBasket_EqualsSumOfUnitsOfUniqueProducts() {
        var sumOFUnitsOfUniqueProducts = 0
        addProductsToCart()
        addProductsToCart() // Addition of more that one type of same 'Product'
        viewModelSUT.getBasketProducts()
        sumOFUnitsOfUniqueProducts = sumOfUnitsOfUniqueCVM()
        XCTAssertEqual(singleton.getAllProducts().count, sumOFUnitsOfUniqueProducts, "The number of products in the singleton array does not match the sum total of unique products")
    }
    // To test that addition of similar products increases the unit count for Unique products
    func testAdditionOfProductsIncresesCountOfUnitUniqueCVM() {
        addProductsToCart()
        viewModelSUT.getBasketProducts()
        let count1 = sumOfUnitsOfUniqueCVM()
        XCTAssertEqual(count1, singleton.getAllProducts().count, "No of products and sum of Units of Unique CVM not same: 1")
        addProductsToCart()
        addProductsToCart() // Addition of more that one type of same 'Product'
        viewModelSUT.getBasketProducts()
        let count2 = sumOfUnitsOfUniqueCVM()
        XCTAssertEqual(count2, singleton.getAllProducts().count, "No of products and sum of Units of Unique CVM not same: 2")
    }
    // To test that removing all products updates the View model appropriately.
    func testRemovingAllProductsUdatesVM() {
        addProductsToCart()
        addProductsToCart() // Addition of more that one type of same 'Product'
        viewModelSUT.getBasketProducts()
        let count1 = sumOfUnitsOfUniqueCVM()
        XCTAssertEqual(count1, singleton.getAllProducts().count, "No of products and sum of Units of Unique CVM not same: 1")
        singleton.removeAllProducts()
        XCTAssertEqual(singleton.getAllProducts().count, 0, "Number of products in checkout singleton is not 0.")
        XCTAssertEqual(viewModelSUT.numberOfProductsIn(Section: 1), 0, "Number of CVM in ViewModel is not 0.")
    }
    func testToCheckIfCalculatedPriceIsAppropriate() {
        addProductsToCart() //<- Price 15, for one invocation
        viewModelSUT.getBasketProducts()
        var price = Int(viewModelSUT.getTotalBasketCost())!
        XCTAssertEqual(price, 15, "Price of products does not match, with contents of cart: 1.")
        addProductsToCart() //<- add 15 again
        viewModelSUT.getBasketProducts()
        price = Int(viewModelSUT.getTotalBasketCost())!
        XCTAssertEqual(price, 30, "Price of products does not match, with contents of cart: 2.")
    }
    // MARK: Helper Methods
    private func addProductsToCart() {
        let mocksProducts = MockProductGenerator().generateMocks()
        for mocksProduct in mocksProducts {
            singleton.addProductTo(Basket: mocksProduct)
        }
    }
    private func sumOfUnitsOfUniqueCVM() -> Int {
        var intToReturn = 0
        for i in 0..<viewModelSUT.numberOfProductsIn(Section: 1) {
            let cvm = viewModelSUT.productForCell(At:  IndexPath(item: i, section: 1))
            if let units = Int(cvm.totalUnits) {
                intToReturn += units
            }
        }
        return intToReturn
    }
}
