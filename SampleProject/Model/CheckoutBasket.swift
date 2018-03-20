//
//  CheckoutBasket.swift
//  SampleProject
//
//  Created by Varun Varman on 01/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import Foundation
protocol CheckoutBasketDelegate: class {
    func basketItemsDidChange()
    func basketDidBecomeEmpty()
}
class CheckoutBasket {
    // MARK: Public API's
    weak var delegate: CheckoutBasketDelegate?
    // MARK: Private API's
    private var basketProducts = [Product]() {
        didSet {
            if basketProducts.count > 0 {
                self.delegate?.basketItemsDidChange()
            } else {
                self.delegate?.basketDidBecomeEmpty()
            }
        }
    }
    // MARK: Shared Instance
    static let sharedInstance = CheckoutBasket()
    // MARK: Private Init
    private init() {
        // code
    }
    // MARK: Methods
    func addProductTo(Basket product: Product) {
        basketProducts.append(product)
        self.delegate?.basketItemsDidChange()
    }
    func removeAllProducts() {
        basketProducts.removeAll()
        delegate?.basketDidBecomeEmpty()
    }
    func getAllProducts() -> [Product] {
        return basketProducts
    }
}
