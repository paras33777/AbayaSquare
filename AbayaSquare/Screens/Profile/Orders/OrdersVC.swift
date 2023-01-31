//
//  OrdersVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class OrdersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    private let router = OrderRouter()
    let viewModel = OrdersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Orders".localized
        router.viewController = self
        router.dataSource = viewModel
        tableView.register(nibName: OrderCell.identifier)
        setupRefreshControl()
        getOrders()
    }
}

extension OrdersVC {
    func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .black
        tableView.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    @objc func startAPI() {
        viewModel.getOrders() {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func getOrders(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: OrdersModel.Response){
        removeSpinner()
        tableView.refreshControl?.endRefreshing()
        viewModel.orders = response.orders ?? []
        viewModel.orders.sort(by: {$0.id.zeroIfNull > $1.id.zeroIfNull})
        checkEmpty()
        tableView.reloadData()
    }
    
    func checkEmpty(){
        viewModel.orders.isEmpty ? (emptyView.isHidden = false ) : (emptyView.isHidden = true)
    }
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
        let model = viewModel.orders[indexPath.row]
        cell.config(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.dataSource?.orderId = viewModel.orders[indexPath.row].id
        router.goToOrderDetails()
    }
}

