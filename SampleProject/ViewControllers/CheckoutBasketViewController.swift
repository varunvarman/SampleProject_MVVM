//
//  CheckoutBasketViewController.swift
//  SampleProject
//
//  Created by Varun Varman on 02/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import UIKit
class CheckoutBasketViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var checkoutTableView: UITableView!
    // MARK: Public API's
    // MARK: Private API's
    private var clearBarButton: UIBarButtonItem!
    lazy private var viewModel: CheckoutBasketListViewModel = {
        return CheckoutBasketListViewModel()
    }()
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateView()
        initiateViewModel()
    }
    private func initiateView() {
        self.navigationItem.title = Constants.ViewTitle.checkout
        self.checkoutTableView.dataSource = self
        self.checkoutTableView.delegate = self
        let wFrame = UIApplication.shared.windows[0].frame
        self.checkoutTableView.tableFooterView = TableFooterView(frame: CGRect(x: 0.0, y: 0.0, width: wFrame.width, height: 60.0) )
        let barButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearCheckoutCart))
        clearBarButton = barButton
        self.navigationItem.rightBarButtonItem = clearBarButton
    }
    private func initiateViewModel() {
        viewModel.tableViewReloadBinding = { [weak self] in
            self?.checkoutTableView.reloadData()
            self?.updateTableFooter()
        }
        viewModel.showAlertBinding = { [weak self] in
            guard let message = self?.viewModel.alertMessage else {
                return
            }
            self?.showAlert(Message: message, handler: { (action) in
                self?.viewModel.alertCompletionHandler?()
            })
        }
        viewModel.getBasketProducts()
    }
    private func updateTableFooter() {
        (self.checkoutTableView.tableFooterView as? TableFooterView)?.setLabel(Price: viewModel.getTotalBasketCost())
    }
    private func showAlert(Message message: String, handler completionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "ALERT", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completionHandler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func clearCheckoutCart() {
        viewModel.removeAllProducts()
    }
}
// MARK: UITableViewDataSource
extension CheckoutBasketViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProductsIn(Section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cvm = viewModel.productForCell(At: indexPath)
        let cell = checkoutTableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.checkoutCell, for: indexPath)
        cell.textLabel?.text = cvm.name
        cell.detailTextLabel?.text = "Units: " + cvm.totalUnits + " Price: " + cvm.totalPrice
        return cell
    }
}
// MARK: UITableViewDelegate
extension CheckoutBasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
// MARK: TableFooterView
class TableFooterView: UIView {
    private var priceLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setTableFooterLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLabel(Price price: String) {
        priceLabel.text = "Checkout Total: " + price
    }
    private func setTableFooterLayout() {
        let buffer: CGFloat = 20.0
        let label = UILabel(frame: CGRect(x: buffer, y: buffer, width: self.frame.width - (buffer * 2), height: buffer) )
        self.addSubview(label)
        priceLabel = label
        setLabel(Price: "0")
    }
}
