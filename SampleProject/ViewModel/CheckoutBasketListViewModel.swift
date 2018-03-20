//
//  CheckoutBasketListViewModel.swift
//  SampleProject
//
//  Created by Varun Varman on 02/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import Foundation
class CheckoutBasketListViewModel {
    // MARK: Public API's
    private (set) var alertMessage: String? {
        didSet {
            self.showAlertBinding?()
        }
    }
    private (set) var alertCompletionHandler: (() -> Void)?
    // MARK: Private API's
    private var basketSingleton = CheckoutBasket.sharedInstance
    private var checkoutBasketCellViewModels = [CheckoutBasketProductCellViewModel]() {
        didSet {
            self.tableViewReloadBinding?()
        }
    }
    init() {
        basketSingleton.delegate = self
    }
    // MARK: Bindings
    var tableViewReloadBinding: (() -> ())?
    var showAlertBinding: (() -> ())?
    // MARK: Methods
    func getBasketProducts() {
        loadCheckoutBasketProductList()
    }
    func numberOfProductsIn(Section section: Int) -> Int {
        return checkoutBasketCellViewModels.count
    }
    func productForCell(At indexpath: IndexPath) -> CheckoutBasketProductCellViewModel {
        return checkoutBasketCellViewModels[indexpath.row]
    }
    func removeAllProducts() {
        if checkoutBasketCellViewModels.isEmpty {
            showAlert(Message: Constants.AlertMessages.cartAlreadyEmpty, with: nil)
        } else {
            showAlert(Message: Constants.AlertMessages.willRemoveItems) { [weak self] in
                self?.emptyBasket()
            }
        }
    }
    func getTotalBasketCost() -> String {
        var totalValue = "0"
        if !checkoutBasketCellViewModels.isEmpty {
            var total: Int = 0
            for cvm in checkoutBasketCellViewModels {
                if let itemCost = Int(cvm.totalPrice) {
                    total += itemCost
                }
            }
            totalValue = String(total)
        }
        return totalValue
    }
    private func emptyBasket() {
        basketSingleton.removeAllProducts()
    }
    private func loadCheckoutBasketProductList() {
        let productsItems = basketSingleton.getAllProducts()
        var cvm = [CheckoutBasketProductCellViewModel]()
        for productItem in productsItems {
            let name = productItem.productName
            let price = String(productItem.productPrice)
            if let index = cvm.index(where: { (basketProductCellItem) -> Bool in
                if basketProductCellItem.name == productItem.productName {
                    return true
                }
                return false
            }) {
                // product exists, update it
                var basketCellViewModel = cvm[index]
                var totalUnits = Int(basketCellViewModel.totalUnits)!
                totalUnits += 1
                basketCellViewModel.totalUnits = String(totalUnits)
                basketCellViewModel.totalPrice = String(totalUnits * productItem.productPrice)
                cvm[index] = basketCellViewModel
            } else {
                // product does not exist, add it
                let cellViewModel = CheckoutBasketProductCellViewModel(name: name, totalPrice: price, totalUnits: String(1))
                cvm.append(cellViewModel)
            }
        }
        checkoutBasketCellViewModels = cvm
    }
    private func showAlert(Message message: String, with completionHandler: (() -> Void)?) {
        alertCompletionHandler = completionHandler
        alertMessage = message
    }
}
// MARK: CheckoutBasketDelegate
extension CheckoutBasketListViewModel: CheckoutBasketDelegate {
    func basketItemsDidChange() {
        // code to handle any changes in the Checkout Basket singleton.
        // you can call loadCheckoutBasketProductList()
        // to iterate throgh the productList and update the checkoutbasketCellViewModel array.
        // loadCheckoutBasketProductList() // <- Uncomment this line for auto updates to cell View Model, not req. in this project scale., if uncommented will require to modify in Test Cases as appropriate.
    }
    func basketDidBecomeEmpty() {
        checkoutBasketCellViewModels.removeAll()
    }
}
struct CheckoutBasketProductCellViewModel {
    var name: String
    var totalPrice: String
    var totalUnits: String
}
