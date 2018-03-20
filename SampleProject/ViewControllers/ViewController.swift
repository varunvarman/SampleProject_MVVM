//
//  ViewController.swift
//  SampleProject
//
//  Created by Varun Varman on 01/03/18.
//  Copyright © 2018 Varun Varman. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    // MARK: Public API's
    lazy var viewModel: ProductListViewModel = {
       return ProductListViewModel()
    }()
    // MARK: Private API's
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        return indicator
    }()
    // MARK: Outlets
    @IBOutlet weak var checkoutBarButton: UIBarButtonItem!
    @IBOutlet weak var productTableView: UITableView!
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateView()
        viewModelBindings()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Resolve UIBarButton Fading issue
        self.checkoutBarButton.isEnabled = false
        self.checkoutBarButton.isEnabled = true
    }
    private func initiateView() {
        self.navigationItem.title = Constants.ViewTitle.products
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.estimatedRowHeight = 50.0
    }
    private func viewModelBindings() {
        viewModel.reloadTableViewBinding = { [weak self] in
            self?.productTableView.reloadData()
        }
        viewModel.showLoadingIndicatorBinding = { [weak self] in
            if let status = self?.viewModel.showLoadingIndicator, status == true {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel.showAlertMessageBinding = { [weak self] in
            guard let message = self?.viewModel.alertMessage else {
                return
            }
            self?.showAlert(With: message)
        }
        viewModel.getData()
    }
    private func showAlert(With message: String) {
        let alert = UIAlertController(title: "ALERT", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            // do nothing, dismiss 'alert'
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfCells(In: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cvm = self.viewModel.cellViewModelFor(IndexPath: indexPath)
        let cell = self.productTableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.listCell, for: indexPath)
        cell.textLabel?.text = cvm.name
        cell.detailTextLabel?.text = cvm.price
        return cell
    }
}
// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productTableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.didSelectCell(at: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

