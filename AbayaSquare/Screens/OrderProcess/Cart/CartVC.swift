//
//  CartVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import SwiftMessages

var totalAmount = ""
var sendAmount = 0.0
var deliveryCost = 0.00
var discountAmount = 0.00
var comingFrom = ""

class CartVC: UIViewController {
    
    @IBOutlet weak var Viewdiscount: UIView!
    @IBOutlet weak var buttonApplyDiscount: UIButton!
    @IBOutlet weak var textFieldDiscounr: UITextField!
    @IBOutlet weak var productsTV: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var subtotalCountLB: UILabel!
    @IBOutlet weak var addAddressLB: UILabel!
    @IBOutlet weak var subTotalLB: UILabel!
    @IBOutlet weak var deliveryCostLB: UILabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountLB: UILabel!
    @IBOutlet weak var vatLB: UILabel!
    @IBOutlet weak var vatDiscountLB: UILabel!
    @IBOutlet weak var totalCostLB: UILabel!
    @IBOutlet weak var buyLB: UILabel!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var addressTypeLB: UILabel!
    @IBOutlet weak var addressDetailsLB: UILabel!
    @IBOutlet weak var deliveryChargesView: UIView!
    @IBOutlet weak var vatView: UIView!
    @IBOutlet weak var promoCodeTextLB: UILabel!
    @IBOutlet weak var promoCodeTF: UITextField!
    @IBOutlet weak var applyPromoCodeButton: UIButton!
//    @IBOutlet weak var couponCodeTextLB: UILabel!
    @IBOutlet weak var couponCodeTF: UITextField!
    @IBOutlet weak var applyCouponCodeButton: UIButton!
    
    private let router = CartRouter()
    var products: [ProductEntity] = []
    let viewModel = CartViewModel()
    let paymentViewModel = PaymentMethodViewModel()
    var isCouponApplied = 0
    var discountList: DiscountModelClass?

    override func viewWillAppear(_ animated: Bool) {
        avialCode.removeAll()
        productAllListId.removeAll()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        products = CoreDataManager.getProdcuts()
        productsTV.reloadData()
        setupAddress()
        setupDetails()
        setupNavigationBar()
        checkEmpty()
        promoCodeTF.text = nil
    
        if UserDefaultsManager.config?.data?.settings?.tax == "0" {
            vatView.isHidden = true
        }
        if !User.isLoggedIn { viewModel.selectedAddress = nil }
      
        if UserDefaultsManager.coupon == nil{
            UserDefaultsManager.isDiscountCodeApplied = false
            totalCostLB.text = viewModel.getTotalCost(addressType: viewModel.selectedAddress?.isInternal ?? 0).clean + " " + MainHelper.shared.currency
            buyLB.text = "Buy".localized + " " + CoreDataManager.getTotalCount().description + " " + "Products".localized
            self.buttonApplyDiscount.setTitle("Apply".localized, for: .normal)
            textFieldDiscounr.text = nil
            self.textFieldDiscounr.isUserInteractionEnabled = true
            self.textFieldDiscounr.placeholder = "Enter discount coupon".localized
            self.viewModel.coupon = nil
            self.productsTV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        router.viewController = self
        router.dataSource = viewModel
    }
//
    func postRequest() {

      // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
        let originalString = viewModel.getTotalCost(addressType: viewModel.selectedAddress?.isInternal ?? 0).clean
        let numberString = originalString.filter({ "1234567890.".contains($0) })
        print(numberString)

        let parameters: [String: Any] = ["code": textFieldDiscounr.text ?? "", "total": numberString,"products": productAllListId]

      // create the url with URL
      let url = URL(string: "https://abayasquare.com/api/v1/check-coupon")! // change server url accordingly

      // create the session object
      let session = URLSession.shared

      // now create the URLRequest object using the url object
      var request = URLRequest(url: url)
      request.httpMethod = "POST" //set http method as POST

      // add headers for the request
      request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
      request.addValue("application/json", forHTTPHeaderField: "Accept")

      do {
        // convert parameters to Data and assign dictionary to httpBody of request
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          print(request.httpBody!)
      } catch let error {
        print(error.localizedDescription)
        return
      }

      // create dataTask using the session object to send data to the server
      let task = session.dataTask(with: request) { data, response, error in

        if let error = error {
          print("Post Request Error: \(error.localizedDescription)")
          return
        }

        // ensure there is valid response code returned from this HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
              
        else {
       DispatchQueue.main.async {
        do{
           let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            print(json!)
            self.removeSpinner()
            MainHelper.shared.showErrorMessage(responseMessage: json!["response_message"] as? String ?? "".localized)
           }catch{
               print("erroMsg")
               
           }

      }
          return
        }

        // ensure there is data returned
        guard let responseData = data else {
          print("nil Data received from the server")
          return
        }

        do {
          // create json object from data or use JSONDecoder to convert to Model stuct
          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
              DispatchQueue.main.async { [self] in
                  self.removeSpinner()
                  MainHelper.shared.showSuccessMessage(responseMessage: jsonResponse["response_message"] as? String ?? "".localized)
                  do{
                      let json = try JSONSerialization.data(withJSONObject: jsonResponse , options: .prettyPrinted)
                      let encodeJson = try JSONDecoder().decode(discountModelClass.self, from: json)
                      self.discountList = encodeJson
                      self.viewModel.coupon = self.discountList?.coupon
                      UserDefaultsManager.isDiscountCodeApplied = true
                      UserDefaultsManager.coupon = self.discountList?.coupon
                      print(jsonResponse)
                      self.textFieldDiscounr.isUserInteractionEnabled = false
                      let discountRatio = self.viewModel.coupon?.discount_ratio ?? 0
                      let total = CoreDataManager.getProductsTotalPriceWithoutDiscount()
                      if self.viewModel.coupon?.flag ?? 0 == 1{
                          let dis = Double(discountRatio)
                          let totalDis = (dis) / 100.00
                          print(totalDis)
                          let price = total * totalDis
                          let mainAmount = total - price + deliveryCost
                          self.totalCostLB.text = "\(mainAmount.clean)" + " " + MainHelper.shared.currency
                          self.discountView.isHidden = false
                          sendAmount = mainAmount
                          self.discountLB.text = price.clean + " " + MainHelper.shared.currency
                          discountAmount = price
                          
                      }else if self.viewModel.coupon?.flag ?? 0 == 2{
                          let dis = Double(discountRatio)
                          let prc = total - dis + deliveryCost
                          self.discountView.isHidden = false
                          self.discountLB.text = Double(discountRatio).clean + " " + MainHelper.shared.currency
                          self.totalCostLB.text = prc.clean + " " + MainHelper.shared.currency
                          sendAmount = prc
                          discountAmount = Double(discountRatio)
                      }else if self.viewModel.coupon?.flag ?? 0 == 3{
                          
                          self.discountView.isHidden = true
                          self.deliveryCostLB.text = "0" + " " + MainHelper.shared.currency
                          let totalCost  = total
                          self.totalCostLB.text = totalCost.clean + " " + MainHelper.shared.currency
                          sendAmount = totalCost
                          discountAmount = deliveryCost
                      }
        
                      self.textFieldDiscounr.resignFirstResponder()
                      self.productsTV.reloadData()
                      self.buttonApplyDiscount.setTitle("Delete".localized, for: .normal)
                  }catch{
                     print("ERROR!")
                  }
          }

            // handle json response
          } else {
            print("data maybe corrupted or in wrong format")
            throw URLError(.badServerResponse)
          }
        } catch let error {
          print(error.localizedDescription)
        }
      }
      // perform the task
      task.resume()
    }
    
    @IBAction func didTapChangeAddress(_ sender: Any) {
        if User.isLoggedIn {
            guard let addresses = User.currentUser?.addresses else {return}
            if addresses.isEmpty {
                router.goToAddAddress()
            } else {
                router.nav = self.navigationController
                router.goToSelectAddress()
            }
        } else {
            router.goToLogin()
        }
    }
    
    @IBAction func didTapGoToCoupons(_ sender: Any) {
        router.goToDisountCodes()
    }
    

    @IBAction func didTapDiscountApply(_ sender: UIButton) {

        if UserDefaultsManager.isPromoCodeApplied {
            MainHelper.shared.showErrorMessage(responseMessage: "Sorry you cant apply a dicount coupon  whenever you applied a promo code coupon".localized)
        } else {
            if !UserDefaultsManager.isDiscountCodeApplied {
                if User.isLoggedIn {
                    sender.showSpinner(spinnerColor: .Color333333,backgroundColor: .white)
                    if self.textFieldDiscounr.text == ""{
                        removeSpinner()
                        MainHelper.shared.showErrorMessage(responseMessage: "Enter discount coupon".localized)
                    }else{
                    self.postRequest()
                    }
                } else {
                    MainHelper.shared.showErrorMessage(responseMessage: "You Must Login".localized)
                }

            } else {
                alertWithCancel(title: "Delete Discount Coupon ".localized, message: "Do you want to Delete Discount Coupon?".localized,OkAction: "Delete".localized) { _ in
                    UserDefaultsManager.isDiscountCodeApplied = false
                    self.textFieldDiscounr.text = nil
                    self.textFieldDiscounr.isUserInteractionEnabled = true
                    self.textFieldDiscounr.placeholder = "Enter discount coupon".localized
                    self.buttonApplyDiscount.setTitle("Apply".localized, for: .normal)
                    self.viewModel.coupon = nil
                    self.productsTV.reloadData()
                    self.setupDetails()
                }
            }
        }
}

    @IBAction func didTapApplyCode(_ sender: UIButton) {

        if UserDefaultsManager.isDiscountCodeApplied {
            MainHelper.shared.showErrorMessage(responseMessage: "Sorry you cant apply a promo code whenever you applied a discount coupon".localized)
        } else {
            if !UserDefaultsManager.isPromoCodeApplied {
                if User.isLoggedIn {
                    sender.showSpinner(spinnerColor: .Color333333,backgroundColor: .white)
                    let request = PromoCodeModel.Request(code: promoCodeTF.text)
                    viewModel.checkPromoCode(request: request) {result in
                        switch result {
                        case .success(let response): self.onSuccess(response)
                        case .failure(let error): self.onFailure(error)
                        }
                    }
                } else {
                    MainHelper.shared.showErrorMessage(responseMessage: "You Must Login".localized)
                }
            } else {
                alertWithCancel(title: "Delete Promo Code".localized, message: "Do you want to Delete promo code?".localized,OkAction: "Delete".localized) { _ in
                    UserDefaultsManager.promoCode = nil
                    UserDefaultsManager.isPromoCodeApplied = false
                    self.promoCodeTF.placeholder = "Apply Promo Code".localized
                    self.applyPromoCodeButton.setTitle("Apply".localized, for: .normal)
                    self.viewModel.discount = nil
                    self.productsTV.reloadData()
                    self.setupDetails()
                }
            }
        }
    }
    
    @IBAction func didTapApplyCouponCode(_ sender: UIButton) {
//        if CoreDataManager.isCouponIsUsedBefore(couponId: viewModel.coupons[row].id) {
//            MainHelper.shared.showErrorMessage(responseMessage: "you Can Use the only one time".localized)
//        } else {
//            CoreDataManager.insert(coupon: viewModel.coupons[row])
//            delegate?.didSelectCoupon(coupon: viewModel.coupons[row])
//            navigationController?.popViewController(animated: true)
//            let designerId = viewModel.coupons[row].designer?.id.int16 ?? 0
//            let codeId = viewModel.coupons[row].id.int16
//            let couponRatio = viewModel.coupons[row].discountRatio.zeroIfNull
//            let code = viewModel.coupons[row].code.emptyIfNull
//            CoreDataManager.updateProduct(designerId: designerId, couponId: codeId, couponRatio: couponRatio, couponCode: code)
//            UserDefaultsManager.isDiscountCodeApplied = true
//            MainHelper.shared.showSuccessMessage(responseMessage: "Discount Code has been applied to all the products in the cart from the designer".localized)
//        }
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        if User.isLoggedIn {
            if viewModel.selectedAddress == nil {
                MainHelper.shared.showErrorWithButton(message: "You Must Add Address".localized, buttonTitle: "Add".localized) { [weak self] _ in
                    SwiftMessages.hideAll()
                    self?.router.goToAddAddress()
                }
            } else {
                router.dataSource?.request.addressId = viewModel.selectedAddress?.id ?? 0
                router.dataSource?.isCashEnabled = viewModel.selectedAddress?.area?.isCash ?? 0
                router.dataSource?.request.products = viewModel.getProductArray()
                router.dataSource?.selectedAddress = viewModel.selectedAddress
                if UserDefaultsManager.isPromoCodeApplied {
                    router.dataSource?.total = viewModel.getTotalWithPromoCodeDiscount(addressType: viewModel.selectedAddress?.isInternal ?? 0)
                }else if UserDefaultsManager.isDiscountCodeApplied{
                    router.dataSource?.total = sendAmount
                  
                } else {
                    router.dataSource?.total = viewModel.getTotalCost(addressType: viewModel.selectedAddress?.isInternal ?? 0)
                }
                router.goToPaymentMethods()
            }
        } else {
            MainHelper.shared.showErrorMessage(responseMessage: "You Must Login to Continue Order".localized)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // your code here
                comingFrom = "cart"
                self.router.goToLogin()
            }
            
        }
    }
    
    @IBAction func continueShopping(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
}

extension CartVC {
    func setupNavigationBar(){
        let title = UILabel()
        let filterString =  NSMutableAttributedString(string: "Cart".localized).with(font: .boldSystemFont(ofSize: 16)).with(textColor: UIColor("#333333"))
        let productCount = NSMutableAttributedString(string: "(\(CoreDataManager.getTotalCount()))").with(font: .boldSystemFont(ofSize: 14)).with(textColor: UIColor("#333333"))
        title.attributedText = [filterString,productCount].joined
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "ic_profile"), style: .plain, target: self, action: #selector(menunButtonPressed))
        
        let categoryButton = UIButton()
        categoryButton.setTitle("Categories".localized, for: .normal)
        categoryButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        categoryButton.setTitleColor(UIColor("#333333"), for: .normal)
        categoryButton.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [menuButton,UIBarButtonItem(customView: categoryButton)]
        navigationItem.titleView = title
    }
    
    @objc func menunButtonPressed(){
        tabBarController?.selectedIndex = 4
    }
    
    func setupDetails(){

        subtotalCountLB.text = "Subtotal".localized + " (\(CoreDataManager.getTotalCount().description) \("Item".localized))"
        subTotalLB.text = CoreDataManager.getProductsTotalPriceWithoutDiscount().clean + " " + MainHelper.shared.currency
        vatLB.text = "Tax".localized + " " + viewModel.getVatValue() + " %"
        vatDiscountLB.text = viewModel.getVatCost().clean + " " + MainHelper.shared.currency
        totalAmount = viewModel.getTotalCost(addressType: viewModel.selectedAddress?.isInternal ?? 0).clean
        if UserDefaultsManager.isPromoCodeApplied {
            viewModel.discount = UserDefaultsManager.promoCode
            products.forEach {
                $0.promoCodeDicount = viewModel.discount?.promoDiscountRatio?.toDouble ?? 0
                productsTV.reloadData()
            }
            applyPromoCodeButton.setTitle("Delete".localized, for: .normal)
            if UserDefaultsManager.promoCode != nil {
                promoCodeTF.placeholder = UserDefaultsManager.promoCode.promoCode
            }
            viewModel.discount = UserDefaultsManager.promoCode
            let total = viewModel.getTotalWithPromoCodeDiscount(addressType: viewModel.selectedAddress?.isInternal ?? 0)
            discountView.isHidden = false
            promoCodeTextLB.text = "Promo Code".localized
            discountLB.text = ("- \(viewModel.getDiscountPromoCode().clean) \(MainHelper.shared.currency)")
            totalCostLB.text = total.clean
          

        }else if  UserDefaultsManager.isDiscountCodeApplied{
            if UserDefaultsManager.coupon == nil{
                UserDefaultsManager.isDiscountCodeApplied = false
                totalCostLB.text = viewModel.getTotalCost(addressType: viewModel.selectedAddress?.isInternal ?? 0).clean + " " + MainHelper.shared.currency
                buyLB.text = "Buy".localized + " " + CoreDataManager.getTotalCount().description + " " + "Products".localized
                self.buttonApplyDiscount.setTitle("Apply".localized, for: .normal)
            }else{
            self.buttonApplyDiscount.setTitle("Delete".localized, for: .normal)
            if UserDefaultsManager.coupon != nil {
                textFieldDiscounr.placeholder = UserDefaultsManager.coupon.code
            }
                let total = CoreDataManager.getProductsTotalPriceWithoutDiscount()

                if UserDefaultsManager.coupon.flag == 1{
                    let dis = Double(UserDefaultsManager.coupon.discount_ratio ?? 0)
                    let totalDis = (dis) / 100.00
                    print(totalDis)
                    let price = total * totalDis
                    let mainAmount = total - price + deliveryCost
                    self.totalCostLB.text = "\(mainAmount.clean)" + " " + MainHelper.shared.currency
                    self.discountView.isHidden = false
                    self.discountLB.text = price.clean + " " + MainHelper.shared.currency
                    sendAmount = mainAmount
                    discountAmount = price
                 
                }else if UserDefaultsManager.coupon.flag  == 2{
                    let dis = Double(UserDefaultsManager.coupon.discount_ratio ?? 0)
                    let prc = total - dis + deliveryCost
                    self.discountView.isHidden = false
                    self.discountLB.text = Double(UserDefaultsManager.coupon.discount_ratio ?? 0).clean + " " + MainHelper.shared.currency
                    self.totalCostLB.text = prc.clean + " " + MainHelper.shared.currency
                    sendAmount = prc
                    discountAmount = Double(UserDefaultsManager.coupon.discount_ratio ?? 0)

                }else if UserDefaultsManager.coupon.flag == 3{
                    self.discountView.isHidden = true
                    self.deliveryCostLB.text = "\(0)" + " " + MainHelper.shared.currency
                    let totalCost  = total
                    self.totalCostLB.text = totalCost.clean + " " + MainHelper.shared.currency
                    sendAmount = totalCost
                    discountAmount = deliveryCost
               
                }

            }
        } else {
            CoreDataManager.getDiscountTotal() == 0 ? (discountView.isHidden = true) : (discountView.isHidden = false)
            totalCostLB.text = viewModel.getTotalCost(addressType: viewModel.selectedAddress?.isInternal ?? 0).clean + " " + MainHelper.shared.currency
            discountLB.text =  " - " + CoreDataManager.getDiscountTotal().clean + " " + MainHelper.shared.currency
            buyLB.text = "Buy".localized + " " + CoreDataManager.getTotalCount().description + " " + "Products".localized
            promoCodeTextLB.text = "Coupon Discount".localized
        }
    }
        
    
    func checkEmpty(){
        if products.isEmpty {
            emptyView.isHidden = false
            UserDefaultsManager.isPromoCodeApplied = false
            UserDefaultsManager.isDiscountCodeApplied = false
            UserDefaultsManager.promoCode = nil
            UserDefaultsManager.coupon = nil
            CoreDataManager.deleteAllCoupons()
        } else {
            emptyView.isHidden = true
        }
    }
    
    func setupAddress(){
        if let addresses = User.currentUser?.addresses {
            if addresses.isEmpty {
                addressView.isHidden = true
                deliveryChargesView.isHidden = true
                addAddressLB.text = "Add".localized
                deliveryCostLB.text = viewModel.getDeliveryCost(addressType: 1).clean + " " + MainHelper.shared.currency
                deliveryCost = viewModel.getDeliveryCost(addressType: 1)
            } else {
                addressView.isHidden = false
                deliveryChargesView.isHidden = false
                addAddressLB.text = "Change".localized
                viewModel.selectedAddress = addresses.last
                let mobile = viewModel.selectedAddress?.mobile ?? ""
                usernameLB.text = "\(viewModel.selectedAddress?.name ?? "") | \(mobile)"
                addressTypeLB.text = viewModel.selectedAddress?.type
                addressDetailsLB.text = viewModel.selectedAddress?.address
                deliveryCostLB.text = viewModel.getDeliveryCost(addressType: viewModel.selectedAddress?.isInternal ?? 0).clean + " " + MainHelper.shared.currency
                deliveryCost = viewModel.getDeliveryCost(addressType: viewModel.selectedAddress?.isInternal ?? 0)
            }
            
        } else {
            addressView.isHidden = true
            deliveryChargesView.isHidden = true
            addAddressLB.text = "Add".localized
        }
    }
    
    func updateProductPrices(){
        let request = UpdateProductPrices(productsList: CoreDataManager.getProductsIds().description)
        viewModel.updateProductPrices(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @objc func categoryButtonPressed(){
        router.goToCategories()
    }
    
    func onSuccess(_ response: HomeModel.Response){
        response.products?.forEach {
            CoreDataManager.updateProducts(product: $0)
        }
        productsTV.reloadData()
    }
    
    func onSuccess(_ response: PromoCodeModel.Response){
        removeSpinner()
        UserDefaultsManager.promoCode = response.promoSettings
        viewModel.discount = response.promoSettings
        promoCodeTF.text = nil
        let total = viewModel.getTotalWithPromoCodeDiscount(addressType: viewModel.selectedAddress?.isInternal ?? 0)
        discountView.isHidden = false
        promoCodeTextLB.text = "Promo Code".localized
        discountLB.text = ("- \(viewModel.getDiscountPromoCode().clean) \(MainHelper.shared.currency)")
        totalCostLB.text = total.clean
        UserDefaultsManager.isPromoCodeApplied = true
        products.forEach {
            $0.promoCodeDicount = viewModel.discount?.promoDiscountRatio?.toDouble ?? 0
        }
        promoCodeTF.resignFirstResponder()
        productsTV.reloadData()
        promoCodeTF.placeholder = UserDefaultsManager.promoCode.promoCode
        applyPromoCodeButton.setTitle("Delete".localized, for: .normal)
        
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let model = products[indexPath.row]
        cell.config(with: model)
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.dataSource?.productId = Int(products[indexPath.row].id)
        router.goToProductDetails()
    }
}

extension CartVC: CartCellDelegate {
    func decreaseProduct(_ cell: CartCell) {
        if let row = productsTV.indexPath(for: cell)?.row {
            let model = products[row]
            CoreDataManager.decreaseQuantity(model)
        }
        if UserDefaultsManager.isDiscountCodeApplied{
            if CoreDataManager.getProductsTotalPriceWithoutDiscount() <= 500{
            UserDefaultsManager.isDiscountCodeApplied = false
            UserDefaultsManager.coupon = nil
            self.textFieldDiscounr.text = nil
            self.textFieldDiscounr.isUserInteractionEnabled = true
            self.textFieldDiscounr.placeholder = "Enter discount coupon".localized
            self.buttonApplyDiscount.setTitle("Apply".localized, for: .normal)
            self.viewModel.coupon = nil
            self.productsTV.reloadData()
        }
    }
        checkEmpty()
        setupDetails()
        setupNavigationBar()
    }
    
    func increaseProduct(_ cell: CartCell) {
        if let row = productsTV.indexPath(for: cell)?.row {
            guard CoreDataManager.isQuantityAvailable(product: products[row]) else {
                MainHelper.shared.showNoticeMessage(message: "Quantity isn't Available".localized)
                cell.quantity -= 1
                return
            }
            let model = products[row]
            CoreDataManager.increaseQuantity(model)
        }

        setupDetails()
        self.productsTV.reloadData()
    }
    
    func deleteProduct(_ cell: CartCell) {
        if let row = productsTV.indexPath(for: cell)?.row {
            let model = self.products[row]
            let deleteAlert = UIAlertController(title: "Delete Prodcut".localized, message: "Do want to delete the Prodcut?".localized , preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Delete".localized, style: .default, handler: { (action: UIAlertAction!) in
                CoreDataManager.deleteProdcut(model)
                self.products.remove(at: row)
                self.productsTV.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                self.productsTV.reloadData()
                self.setupDetails()
                self.checkEmpty()
                self.setupNavigationBar()
                NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
                cell.quantity += 1
                CoreDataManager.increaseQuantity(model)
                self.setupDetails()
            }))
            
            present(deleteAlert, animated: true, completion: nil)
            
            
        }
    }
    
    func likeProduct(_ cell: CartCell) {
        if User.isLoggedIn {
            if let row = productsTV.indexPath(for: cell)?.row {
                let product = products[row]
                (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false)
                cell.updateFav(product)
                let request = AddToFavorite.Request(productId: Int(product.id))
                viewModel.addToFav(request: request) { result in
                    switch result {
                    case .success(_): NotificationCenter.default.post(name: .DidRemoveFavorite, object: nil)
                    case .failure(_): (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false); cell.updateFav(product)
                    }
                }
            }
        } else {
            MainHelper.shared.showErrorMessage(responseMessage: "You Must Login to like the product".localized)
        }
    }
}

extension CartVC: AddAddressDelegate {
    func didAddAddress(addressType: Int) {
        deliveryCostLB.text = viewModel.getDeliveryCost(addressType: addressType).clean + " " + MainHelper.shared.currency
        setupDetails()
    }
}

extension CartVC: SelectAddressDelegate{
    func didSelectAddress(address: Address) {
        viewModel.selectedAddress = address
        let mobile = String(viewModel.selectedAddress?.mobile?.suffix(9) ?? "")
        usernameLB.text = "\(viewModel.selectedAddress?.name ?? "") | \(mobile)"
        addressTypeLB.text = viewModel.selectedAddress?.type
        addressDetailsLB.text = viewModel.selectedAddress?.address
        deliveryCostLB.text = viewModel.getDeliveryCost(addressType: address.isInternal ?? 0).clean + " " + MainHelper.shared.currency
        setupDetails()
    }
}

extension CartVC: DiscountCodesDelegate {
    func didSelectCoupon(coupon: Offer) {
        isCouponApplied = 1
        productsTV.reloadData()
    }
}
