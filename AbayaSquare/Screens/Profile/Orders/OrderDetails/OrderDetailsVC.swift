//
//  OrderDetailsVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit
import SafariServices
class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderIdLB: UILabel!
    @IBOutlet weak var orderOnLB: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNameLB: UILabel!
    @IBOutlet weak var productsCount: UILabel!
    @IBOutlet weak var orderStatusTV: UITableView!
    @IBOutlet weak var productsTV: UITableView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var addressTypeLB: UILabel!
    @IBOutlet weak var addressDetails: UILabel!
    @IBOutlet weak var cancelOrderStack: UIStackView!
    @IBOutlet weak var subtotalCountLB: UILabel!
    @IBOutlet weak var subTotalLB: UILabel!
    @IBOutlet weak var deliveryCostLB: UILabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountLB: UILabel!
    @IBOutlet weak var vatLB: UILabel!
    @IBOutlet weak var vatDiscountLB: UILabel!
    @IBOutlet weak var totalCostLB: UILabel!
    @IBOutlet weak var vatView: UIView!
    @IBOutlet weak var couponCodeText: UILabel!
    @IBOutlet weak var walletStack: UIStackView!
    @IBOutlet weak var walletLB: UILabel!
    @IBOutlet weak var amountToPayLB: UILabel!
    
    let viewModel = OrderDetailsViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Details".localized
        productsTV.register(nibName: OrderCell.identifier)
        setupRefreshControl()
        getOrderDetails()
    }
    
    @IBAction func didTapDownloadInvoice(_ sender: Any) {
        guard let invoice = viewModel.order?.invoiceUrl else {return}
        let url: URL! = URL(string: invoice)
        let svc = SFSafariViewController(url: url! as URL)
        svc.delegate = self
        svc.title = "Invoice".localized
        navigationController?.pushViewController(svc, animated: true)
    }
    
    @IBAction func didTapCancelOrder(_ sender: UIButton) {
        sender.showSpinner(spinnerColor: .black, backgroundColor: UIColor("#FFEAED"))
        let orderId = viewModel.orderId.zeroIfNull
        let request = OrdersModel.CancelOrder(orderId: orderId)
        viewModel.cancelOrder(request: request) {result in
            switch result {
            case .success(_): self.onSuccessCancelOrder()
            case .failure(let error): self.onFailure(error)
            }
        }
    }
}

extension OrderDetailsVC {
    
    func setupRefreshControl() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.tintColor = .black
        scrollView.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func getOrderDetails(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    @objc func startAPI(){
        let request = OrdersModel.GetOrderDetails(orderId: viewModel.orderId.zeroIfNull)
        viewModel.getOrderDetails(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: OrdersModel.GetOrderDetailsResponse){
        viewModel.order = response.order
        setupDetails()
        scrollView.refreshControl?.endRefreshing()
        removeSpinner()
    }
    
    func setupDetails(){
        guard let order = viewModel.order else {return}
        orderIdLB.text = order.name
        let orderDate = order.createdAt?.components(separatedBy: " ") ?? []
        let year = orderDate[0].components(separatedBy: "-")
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        let number = Int(year[1]) ?? 0
        let monthName = fmt.shortMonthSymbols[number - 1]
        orderOnLB.text = year[0] + " - " + monthName + " - " + year[2]
        orderImage.image = UIImage(named: "logo_auth")
        orderNameLB.text = order.name
        viewModel.products = order.products ?? []
        productsTV.reloadData()
        productsCount.text = "Products Count: ".localized + viewModel.products.count.description
        subtotalCountLB.text = "Subtotal".localized + " (\(viewModel.products.count.description) \("Item".localized))"
        subTotalLB.text = order.subTotal1.zeroIfNull.clean + " " + MainHelper.shared.currency
        deliveryCostLB.text = order.deliveryCost.zeroIfNull.clean + " " + MainHelper.shared.currency
        
        if order.taxRatio == 0 {
            vatView.isHidden = true
        }
        
        vatLB.text = "Tax".localized + " " + order.taxRatio.zeroIfNull.clean + " %"
        vatDiscountLB.text = order.tax.zeroIfNull.clean + " " + MainHelper.shared.currency
        totalCostLB.text = order.total.zeroIfNull.clean + " " + MainHelper.shared.currency
        
        viewModel.orderCases = order.statusLog ?? []
        
        if order.status?.id == 2 {
            viewModel.orderCases.append(StatusLog(status: Status(id: 8, name: "Shipped".localized)))
            viewModel.orderCases.append(StatusLog(status: Status(id: 9, name: "Delivered".localized)))
        }
        
        orderStatusTV.reloadData()
        
        if order.discount.zeroIfNull != 0 {
            discountView.isHidden = false
            discountLB.text = order.discount.zeroIfNull.clean + " " + MainHelper.shared.currency
        }
        
        guard let address = order.address else {return}
        let mobile = address.mobile ?? ""
        usernameLB.text = "\(address.name ?? "") | \(mobile)"
        addressTypeLB.text = address.type
        addressDetails.text = address.address
        
        if order.status?.id == 1 {
            cancelOrderStack.isHidden = false
        } else {
            cancelOrderStack.isHidden = true
        }
        
        if order.promoCode != nil {
            couponCodeText.text = "Promo Code".localized
        }
        
        if order.useWallet == 1 {
            walletStack.isHidden = false
            walletLB.text = order.usedWalletAmount.zeroIfNull.clean + " " + MainHelper.shared.currency
            let total = order.total.zeroIfNull - order.usedWalletAmount.zeroIfNull 
            amountToPayLB.text = total.clean + " " + MainHelper.shared.currency
        }
    }
    
    func onSuccessCancelOrder(){
        if viewModel.order!.paymentType == 6 {
            var amount = 0.0
            if viewModel.order!.tabyPaymentRef == "Installments" {
                amount = (viewModel.order!.total.zeroIfNull) / 4
            } else {
                amount = viewModel.order!.total.zeroIfNull
            }
            let request = TabbyRefundPayment.Request(amount: amount.clean, reason: "cancel order")
            viewModel.refundTabbyPayment(request: request ,paymentId: viewModel.order?.paymentId ?? "") { [self] result in
                switch result {
                case .success(_):
                    navigationController?.popViewController(animated: true)
                case .failure(let error):
                    MainHelper.shared.showErrorMessage(responseMessage: error.errorDescription ?? "" )
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
        removeSpinner()
        startAPI()
    }
    
    func onSuccessReturnProduct() {
        MainHelper.shared.showSuccessMessage(responseMessage: "Order Has been Returned".localized)
        removeSpinner()
    }
}

extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderStatusTV {
            return viewModel.orderCases.count
        } else {
            return viewModel.products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderStatusTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCellTV", for: indexPath) as!
                OrderStatusCellTV
            let model = viewModel.orderCases[indexPath.row]
            cell.config(with: model)
            
            if viewModel.orderCases.count > 1 {
                if indexPath.row == viewModel.orderCases.count - 1 {
                    cell.dashLineView.isHidden = true
                } else {
                    cell.dashLineView.isHidden = false
                }
            }
            
            if viewModel.order?.status?.id == 2 {
                cell.checkView.backgroundColor = UIColor("#B6B6B6")
                cell.statusLB.textColor = UIColor("#B6B6B6")
                cell.dashLineView.borderColor = UIColor("#B6B6B6")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
            let model = viewModel.products[indexPath.row]
            cell.config(with: model)
            
            if viewModel.order?.status?.id == 5 {
                cell.returnView.isHidden = false
            }
            
            cell.delegate = self
            return cell
        }
    }
}

extension OrderDetailsVC: OrderCellDelegate {
    func didReturnProduct(_ cell: OrderCell) {
        if let index = productsTV.indexPath(for: cell)?.row{
            let orderId = viewModel.products[index].orderId.zeroIfNull
            let productId = viewModel.products[index].product?.id ?? 0
            let request = OrdersModel.ReturnProduct(orderId: orderId, orderProductId: productId)
            cell.returnView.showSpinner(spinnerColor: .black, backgroundColor: UIColor("#DCDCDC"))
            viewModel.returnProduct(request: request) {result in
                switch result {
                case .success(_):
                    self.onSuccessReturnProduct()
                    cell.returnView.isHidden = true
                case .failure(let error): self.onFailure(error)
                }
            }
        }
        
    }
}

extension OrderDetailsVC: SFSafariViewControllerDelegate {
    //    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool)
    //    {
    //        let f = CGRect(origin: CGPoint(x: 0, y: 0),
    //                       size: CGSize(width: 90, height: 44))
    //        let uglyView = UIView(frame: f)
    //        uglyView.backgroundColor = .lightGray
    //        controller.view.addSubview(uglyView)
    //    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
}
