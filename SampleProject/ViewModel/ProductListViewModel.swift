//
//  ProductListViewModel.swift
//  SampleProject
//
//  Created by Varun Varman on 01/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import Foundation
class ProductListViewModel {
    // MARK: Public API's
    private (set) var showLoadingIndicator: Bool = false {
        didSet {
            self.showLoadingIndicatorBinding?()
        }
    }
    private (set) var alertMessage: String? {
        didSet {
            self.showAlertMessageBinding?()
        }
    }
    // MARK: Private API's
    private var apiService: APIServiceProtocol?
    private var products: [Product] = [Product]()
    private var basketSingleton = CheckoutBasket.sharedInstance
    private var cellViewModels: [ProductListCellViewModel] = [ProductListCellViewModel]() {
        didSet {
            self.reloadTableViewBinding?()
        }
    }
    // MARK: Bindings
    var reloadTableViewBinding: (() -> Void)?
    var showLoadingIndicatorBinding: (() -> Void)?
    var showAlertMessageBinding: (() -> Void)?
    // MARK: init
    init(service apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    // MARK: Methods
    func getData() {
        self.showLoadingIndicator = true
        apiService?.fetchData { [weak self] (products, error) in
            self?.showLoadingIndicator = false
            if let err = error {
                self?.alertMessage = err.rawValue
            } else if let items = products {
                self?.createProductCellViewModel(from: items)
                self?.reloadTableViewBinding?()
            } else {
                print(Constants.AlertMessages.unknownError)
                self?.alertMessage = Constants.AlertMessages.unknownError
            }
        }
    }
    func numberOfProducts() -> Int {
        return cellViewModels.count
    }
    func numberOfCells(In section: Int) -> Int {
        return cellViewModels.count
    }
    func cellViewModelFor(IndexPath indexPath: IndexPath) -> ProductListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    func didSelectCell(at indexPath: IndexPath) {
        let cellViewModel = cellViewModels[indexPath.row]
        basketSingleton.addProductTo(Basket: products[indexPath.row])
        self.alertMessage = "1 \(cellViewModel.name) was succesfully added to your shopping cart."
    }
    private func createProductCellViewModel(from items: [Product]) {
        self.products = items
        var cvm = [ProductListCellViewModel]()
        for item in items {
            let name = item.productName
            let price = String( item.productPrice )
            cvm.append( ProductListCellViewModel(name: name, price: price) )
        }
        self.cellViewModels = cvm
    }
}
// MARK: ProductListCellViewModel
struct ProductListCellViewModel {
    var name: String
    var price: String
}
