//
//  PaymentMethodVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//
import UIKit
import Urway
import PassKit
import Tabby
import SwiftUI
import Alamofire
import TamaraSDK
extension String {
    var decoded : String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
}
class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var heightContraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var totalLB: UILabel!
    @IBOutlet weak var paymentMethodsCV: UICollectionView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var balanceStack: UIStackView!
    @IBOutlet weak var balanceLB: UILabel!
    @IBOutlet weak var notEnoughLB: UILabel!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var tabbyView: UIView!
    @IBOutlet var tabbyButtons: [TabbySelectButton]!
 
    @IBOutlet weak var buttonTamaraPayLater: UIButton!
    @IBOutlet weak var buttonTamaraInstallment: UIButton!
    @IBOutlet weak var viewTamara: UIView!
    let viewModel = PaymentMethodViewModel.shared
    var balance = 0.0
    let router = PaymentMethodRouter()
    
    var orderidTamara = ""
    
    var isTokenEnabled: Bool = true
    var paymentController: UIViewController? = nil
    var paymentString: NSString = ""
    var isApplePayPaymentTrxn:Bool = false
    var isSucessStatus: Bool = false
    var tamaraSDK: TamaraSDKCheckout!
    var tamaraPaymentType = ""
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment Method".localized
        router.viewController = self
        router.dataSource = viewModel
        totalLB.text = "\(String(format: "%.2f",viewModel.total))" + " " + MainHelper.shared.currency
        updateUserData()
        getPaymetMethods()
        print("viewModel.isCashEnabled: \(viewModel.isCashEnabled)")
        self.buttonTamaraPayLater.alpha = 0.5
        self.buttonTamaraPayLater.isUserInteractionEnabled = false
        
//        self.updateTamara2()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = paymentMethodsCV.collectionViewLayout.collectionViewContentSize.height
        heightContraintCollectionView.constant = height
        self.view.layoutIfNeeded()
    }
    
    convenience init(){
        self.init()
    }
    
    
    @IBAction func didTapTabbyButtons(_ sender: TabbySelectButton) {
        sender.didTap()
        tabbyButtons.forEach { $0 == sender ? $0.select() : $0.deselect() }
    }
    
    @IBAction func didTapInstallments(_ sender: TabbySelectButton) {
        viewModel.tabbyPaymentType = .Installments
        viewModel.request.ref = "Installments"
    }
    
    @IBAction func didTapPayLater(_ sender: TabbySelectButton) {
        viewModel.tabbyPaymentType = .PayLater
        viewModel.request.ref = "PayLater"
    }
    
    @IBAction func didTapCheck(_ sender: UIButton) {
        if balance == 0 {
            MainHelper.shared.showErrorMessage(responseMessage: "You Don't Have Balance in wallet".localized)
        } else {
            if sender.isSelected {
                viewModel.request.useWallet = 0
                sender.isSelected = false
                UIView.animate(withDuration: 0.15) {
                    self.balanceStack.isHidden = true
                }
            } else {
                sender.isSelected = true
                viewModel.request.useWallet = 1
                UIView.animate(withDuration: 0.015) {
                    self.balanceStack.isHidden = false
                }
            }
        }
    }
    
    @IBAction func didTapUseBalance(_ sender: Any) {
        if balance == 0 {
            MainHelper.shared.showErrorMessage(responseMessage: "You Don't Have Balance in wallet".localized)
        } else {
            if checkButton.isSelected {
                viewModel.request.useWallet = 0
            } else {
                viewModel.request.useWallet = 1
            }
            didTapCheck(checkButton)
        }
    }

    @IBAction func didTapTamaraPayLater(_ sender: UIButton) {
        
        buttonTamaraPayLater.layer.cornerRadius = 6
        buttonTamaraPayLater.backgroundColor = UIColor("#7C7160")
        buttonTamaraPayLater.titleLabel?.font  = .boldSystemFont(ofSize: 15)
        buttonTamaraPayLater.setTitleColor(.white, for: .normal)
        buttonTamaraPayLater.layer.borderWidth = 0
        self.tamaraPaymentType = "PAY_BY_LATER"
        buttonTamaraInstallment.layer.backgroundColor = UIColor.white.cgColor
        buttonTamaraInstallment.layer.borderColor = UIColor("#7C7160").cgColor
        buttonTamaraInstallment.titleLabel?.font  = .systemFont(ofSize: 15)
        buttonTamaraInstallment.layer.borderWidth = 1
        buttonTamaraInstallment.setTitleColor(UIColor("#2C2826"), for: [])
    }
    @IBAction func didTapTamaraInstallMent(_ sender: UIButton) {
        
        buttonTamaraInstallment.layer.cornerRadius = 6
        buttonTamaraInstallment.backgroundColor = UIColor("#7C7160")
        buttonTamaraInstallment.titleLabel?.font  = .boldSystemFont(ofSize: 15)
        buttonTamaraInstallment.setTitleColor(.white, for: .normal)
        buttonTamaraInstallment.layer.borderWidth = 0
        self.tamaraPaymentType = "PAY_BY_INSTALMENTS"
        buttonTamaraPayLater.layer.backgroundColor = UIColor.white.cgColor
        buttonTamaraPayLater.layer.borderColor = UIColor("#7C7160").cgColor
        buttonTamaraPayLater.titleLabel?.font  = .systemFont(ofSize: 15)
        buttonTamaraPayLater.layer.borderWidth = 1
        buttonTamaraPayLater.setTitleColor(UIColor("#2C2826"), for: [])
    }
    
    
    
    @IBAction func didTapSendOrder(_ sender: UIButton) {
        
        if viewModel.request.paymentTypeId == 10{
            self.viewTamara.isHidden = false
            if self.tamaraPaymentType == ""{
                MainHelper.shared.showErrorMessage(responseMessage: "You Have to Select Payment type".localized)
            }else{
                
                if viewModel.total < 100{
//                    let alert = UIAlertController(title: "Alert", message: "Payable amount is low, Please try other payment method", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
                    MainHelper.shared.showErrorMessage(responseMessage: "Payable amount is low, Please try other payment method".localized)
                    
                }else{
                    sender.showSpinner(spinnerColor: .white)
//                    self.checkout()
                    addOrder()

                    
                }
            }
         
        }else{
        if User.isActivated {
            if viewModel.request.useWallet == 0 {
                if viewModel.request.paymentTypeId == 0 {
                    MainHelper.shared.showErrorMessage(responseMessage: "You Have to Select Payment type".localized)
                } else {
                    sender.showSpinner(spinnerColor: .white)
                    addOrder()
                }
            } else {
                if balance < viewModel.total{
                    if viewModel.request.paymentTypeId == 0 {
                        MainHelper.shared.showErrorMessage(responseMessage: "You Have to Select Payment type".localized)
                    } else {
                        sender.showSpinner(spinnerColor: .white)
                        addOrder()
                    }
                } else {
                    sender.showSpinner(spinnerColor: .white)
                    viewModel.request.paymentTypeId = 4
                    addOrder()
                }
            }
        } else {
            MainHelper.shared.showErrorMessage(responseMessage: "This Account is Unavailable".localized)
        }
        }
    }
}

extension PaymentMethodVC {
    
    func onSuccess(_ response: TamaraModel.Response){

    }
    
    
    func setupTabbyPayment(){
        let buyer = TabbyBuyerModel(email: viewModel.email,
                                    phone: String(viewModel.mobile),
                                    name: viewModel.name)
        
        var items: [TabbyOrderItems] = []
        
        CoreDataManager.getProdcuts().forEach {
            items.append(TabbyOrderItems(title: $0.name,
                                         referenceId: "\($0.id)",
                                         unitPrice: "\($0.discountPrice)", quantity: Int($0.quantity)))
            
        }
        
        let isInternal = viewModel.selectedAddress?.isInternal ?? 0
        
        var shippingAmount = ""
        
        if isInternal == 1 {
            shippingAmount = UserDefaultsManager.config.data?.settings?.internalShippingCost ?? ""
        } else {
            shippingAmount = UserDefaultsManager.config.data?.settings?.externalShippingCost ?? ""
        }
        
        let order = TabbyOrder(taxAmount: UserDefaultsManager.config.data?.settings?.tax,
                               shippingAmount: shippingAmount,
                               discountAmount: "0", referenceId: UUID().uuidString, items: items)
        
        let orderHistory: [TabbyOrderHistory] = [TabbyOrderHistory  (amount: viewModel.total.clean,
                                                                     items: items)]
        
        let shippingAddress = TabbyShippingAddress(city: viewModel.selectedAddress?.area?.name,
                                                   address: viewModel.selectedAddress?.address)
        
        let payment = TabbyPaymentModel(amount: viewModel.total.clean,
                                        currency: "SAR",
                                        description: "Abaya Square Order",
                                        buyer: buyer,
                                        buyerHistory: TabbyBuyerHistory(),
                                        order: order,
                                        orderHistory: orderHistory,
                                        shippingAddress: shippingAddress)
        
        
        let request = TabbyCheckoutRequestModel(payment: payment,
                                                lang: L102Language.isRTL ? "ar" : "en",
                                                merchantCode: "AbayaSquare")
        viewModel.checkoutOrder(request: request) {[self] result in
            switch result {
            case .success(let response): onSuccess(response)
            case .failure(let error): onFailure(error)
            }
        }
    }
    
    func getPaymetMethods(){
        view.showSpinner(spinnerColor: .black)
        viewModel.getPaymentMethods() {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func updateUserData(){
        viewModel.updateUserData {result in
            switch result {
            case .success(let response): self.onSuccessUpdateData(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccessUpdateData(_ response: AuthModel.Response){
        if let user = response.customer {
            User.currentUser = user
            balance = user.wallet.zeroIfNull
        }
        calulateBalance()
    }
    func onSuccess(_ response: PaymentMethodModel.Response){
        removeSpinner()
        viewModel.payments.removeAll()
        if avialCode.contains(0){
        for id in response.paymentTypes ?? []{
                if id.id == 1{

                }else{
                    viewModel.payments.append(id)
                }
            }
        }else{
            viewModel.payments = response.paymentTypes ?? []
           
        }
            if viewModel.isCashEnabled == 0 {
                viewModel.payments.removeAll(where: {$0.id == 1})
            }
            paymentMethodsCV.reloadData()
    }
    
    func addOrder(){
        if UserDefaultsManager.isPromoCodeApplied {
            viewModel.request.promoCode = UserDefaultsManager.promoCode.promoCode
        
        }
        if UserDefaultsManager.isDiscountCodeApplied{
            viewModel.request.products[0].couponId = Int16(UserDefaultsManager.coupon.id ?? 0)
            viewModel.request.discount_amount = Int(discountAmount)
          
       
        }
        viewModel.addOrder { result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: AddOrderModel.Response) {
        if response.status == false {
            MainHelper.shared.showErrorMessage(responseMessage: response.responseMessage.emptyIfNull)
        } else {
            
            CoreDataManager.getProdcuts().forEach {
                CoreDataManager.insert(coupon: $0.couponId)
            }
            
            UserDefaultsManager.isDiscountCodeApplied = false
            UserDefaultsManager.isPromoCodeApplied = false
            UserDefaultsManager.promoCode = nil
            UserDefaultsManager.coupon = nil
            viewModel.addOrderResponse = response
            if let transaction = response.order?.paymentTransactionUrl {
                if viewModel.request.paymentTypeId == 10{ // 10 is Tamara payment Id:
                   checkout()
                }else{
                    router.dataSource?.paymentTransactionUrl = transaction
                    router.goToPaymentWebView()
                }
            } else {
                // 5 is apple pay payment id:
                if viewModel.request.paymentTypeId == 5 {
                    isApplePayPaymentTrxn = true
                    applePaymentconfigureSDK()
                    applePayButtonAction()
                } else if viewModel.request.paymentTypeId == 6 { // 6 is tappy payment id:
                    setupTabbyPayment()
                }else if viewModel.request.paymentTypeId == 10{ // 10 is Tamara payment Id:
                   checkout()
                }else {
                    router.dataSource?.isPaymentCash = 1
                    router.goToSuccess()
                }
            }
        }
        removeSpinner()
    }
    
    func onSuccess(_ response: TabbyCheckoutResponse) {
        removeSpinner()
        switch viewModel.tabbyPaymentType {
        case .Installments:
            if let webUrl = response.configuration?.availableProducts?.installments?[0].webUrl {
                router.dataSource?.paymentTransactionUrl = webUrl
                viewModel.request.ref = "Installments"
            }
        case .PayLater:
            if let webUrl = response.configuration?.availableProducts?.payLater?[0].webUrl {
                router.dataSource?.paymentTransactionUrl = webUrl
                viewModel.request.ref = "PayLater"
            }
        }
        viewModel.tabbyPaymentResponse = response
        router.goToPaymentWebView()
    }
    
    func calulateBalance(){
        balanceLB.text = "You Have".localized + " " + balance.clean + " " + MainHelper.shared.currency
        if balance < viewModel.total {
            notEnoughLB.isHidden = false
        }
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    //MARK: - APPLE PAYMENT CODE initialize:
    func initializeSDK() {
        UWInitialization(self) { (controller , result) in
            self.paymentController = controller
            guard let nonNilController = self.paymentController else {return}
            print("initialSDK")
            self.navigationController?.pushViewController(nonNilController, animated: true)
        }
    }
    
    func applePaymentconfigureSDK() {

        let terminalId = "abayasqr"
        let password = "abayasqr@URWAY_123"
        let merchantKey = "a2ec7e094975aabddf7486aef9fa1c1dd3ad3e43cb913dd24b1172580417002c"
        let url = "https://payments.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
        UWConfiguration(password: password, merchantKey: merchantKey, terminalID: terminalId , url: url)
      
//
//        let terminalId = "abayasq"
//            let password = "abayasq@123"
//            let merchantKey = "8d6dd0336b3f603bd5a5e0e64714cb92483d3129f1c420f56b24438ba6512234"
//            let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
//            UWConfiguration(password: password, merchantKey: merchantKey, terminalID: terminalId , url: url)
    }
    
    func applePayButtonAction(){
        UWInitialization(self){ (controller , result) in
            self.paymentController = controller
        }
        
        isSucessStatus = true
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.selsela.abayasquaree"
        request.supportedNetworks = [.quicPay, .masterCard, .visa , .amex , .discover , .mada]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "SA"
        request.currencyCode = "SAR"
        
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "AbayaSquare",amount: NSDecimalNumber(floatLiteral: viewModel.total))]
        
        print("apple pay request: \(request)")
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
        }
    }
    
    func confirmApplePayPayment(request: ConfirmPaymentRequest){
        viewModel.confirmPayment(request: request) {[self] result in
            switch result {
            case .success(_) : router.goToSuccess()
            case .failure(let error): onFailure(error)
            }
        }
    }
    
    
//   MARK: - FUNCTION TAMARA PAYMENT
    func checkout() {
                
          let tamaraCheckout = TamaraCheckout(endpoint: HOST, token: MERCHANT_TOKEN)

        let totalAmountObject = TamaraAmount(amount: "\(String(format: "%.2f",viewModel.total))", currency: currency)
          
          let taxAmountObject = TamaraAmount(amount: "\(0.00)", currency: currency)
          
          let shippingAmountObject = TamaraAmount(amount: "\(deliveryCost)", currency: currency)
        
        let discountAmountObject = TamaraDiscount(name: "Discount", amount: TamaraAmount(amount: "\(discountAmount)", currency: currency))

          var itemList: [TamaraItem] = []
        
        var couunt = 0
        CoreDataManager.getProdcuts().forEach {
            couunt = couunt + 1
            itemList.append(TamaraItem(referenceID: "\($0.id)", type: "Digital", name:  $0.name ?? "", sku: "SKU-\(couunt)", quantity: Int($0.quantity), unitPrice: TamaraAmount(amount: "\($0.discountPrice)", currency: currency), discountAmount: TamaraAmount(amount: "0.0", currency: currency), taxAmount: TamaraAmount(amount: "0.0", currency: currency), totalAmount: TamaraAmount(amount: "\($0.price)", currency: currency)))
      
        }
         
          
          let shippingAddress = TamaraAddress(
            firstName:viewModel.selectedAddress?.name ?? "",
              lastName: viewModel.selectedAddress?.name ?? "",
            line1: viewModel.selectedAddress?.address ?? "",
            line2: viewModel.selectedAddress?.address ?? "" ,
              region: "Riyadh",
            city:viewModel.selectedAddress?.area?.name ?? "",
              countryCode: "SA",
            phoneNumber: "\(viewModel.mobile)"
          )

          let billingAddress = TamaraAddress(
              firstName: "Abaya Square",
              lastName: "Abaya Square",
              line1: "Al Qalaa, Street",
              line2: "Al Qalaa, Street",
              region: "Riyadh",
              city: "Riyadh",
              countryCode: "SA",
              phoneNumber: "\(0530076074)"
          )
          
        let merchantUrl = TamaraMerchantURL(
//            success : "https://example.com/checkout/cancel",
//            failure : "https://example.com/checkout/failure",
//            cancel : "https://example.com/payments/tamarapay",
//            notification : "https://example.com/checkout/success"
            
            success : "https://abayasquare.com/api/v1/success_tamara",
            failure : "https://abayasquare.com/api/v1/failure_tamara",
            cancel : "https://abayasquare.com/api/v1/cancel_tamara",
            notification : "https://abayasquare.com/api/v1/notification_tamara"
        )
        
          
          let consumer = TamaraConsumer(
              firstName: viewModel.selectedAddress?.name ?? "",
              lastName: viewModel.selectedAddress?.name ?? "",
              phoneNumber: String(viewModel.mobile),
              email:UserDefaultsManager.config.data?.settings?.email ?? "",
              nationalID: "",
              dateOfBirth: "",
              isFirstOrder: true
          )
          
  
          let requestBody = TamaraCheckoutRequestBody(
              orderReferenceID: UUID().uuidString,
              totalAmount: totalAmountObject,
              description: "description",
              countryCode: "SA",
              paymentType: self.tamaraPaymentType,
              locale: "en-US",
              items: itemList,
              consumer: consumer,
              billingAddress: billingAddress,
              shippingAddress: shippingAddress,
              discount: discountAmountObject,
              taxAmount: taxAmountObject,
              shippingAmount: shippingAmountObject,
              merchantURL: merchantUrl,
              platform: "iOS",
              isMobile: true,
              riskAssessment: nil
          )

        self.orderidTamara = requestBody.orderReferenceID
        
          tamaraCheckout.processCheckout(body: requestBody, checkoutComplete: { (checkoutSuccess) in
              // Handle success case
              
             
              DispatchQueue.main.async {
                  self.removeSpinner()
                  guard let item = checkoutSuccess else {return}
                  self.tamaraSDK = TamaraSDKCheckout(url: item.checkoutUrl, merchantURL: merchantUrl)
                  self.tamaraSDK.delegate = self
                  self.present(self.tamaraSDK, animated: true, completion: nil)
              }
              
              
          }, checkoutFailed: { (checkoutFailed) in
              // Handle failed case
              
              
              print(checkoutFailed?.message ?? "")
              
              DispatchQueue.main.async {
                  //Handel error
                  self.removeSpinner()
              }
          })
        
       
      }
      
  }


extension PaymentMethodVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.payments.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell

               
        let model = viewModel.payments[indexPath.row]
        cell.config(with: model)
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

                return CGSize(width: (collectionView.frame.size.width - 10) / 2 , height: 104)


    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.request.paymentTypeId = viewModel.payments[indexPath.row].id
        
        if viewModel.request.paymentTypeId == 6 {
            UIView.animate(withDuration: 0.25) {
                self.tabbyView.isHidden = false
                self.balanceView.isHidden = true
                self.viewTamara.isHidden = true
            }
        }else if viewModel.request.paymentTypeId == 10{
            UIView.animate(withDuration: 0.25) {
                self.viewTamara.isHidden = false
                self.balanceView.isHidden = true
                self.tabbyView.isHidden = true
            }
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.viewTamara.isHidden = true
                self.tabbyView.isHidden = true
                self.balanceView.isHidden = false
            }
        }
    }
}


//MARK: - APPLE PAYMENT CODE (Pass Kit):
extension PaymentMethodVC : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        isSucessStatus ? self.initializeSDK() : nil
        print("Apple pay Done")
        
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        paymentString = UWInitializer.generatePaymentKey(payment: payment)
        print("self.paymentString: \(paymentString)")
        isSucessStatus = true
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}

//MARK: - APPLE PAYMENT CODE (Urway Kit):
extension PaymentMethodVC: Initializer {
    
    func prepareModel() -> UWInitializer {
        let model = UWInitializer.init(amount: viewModel.total.clean,
                                       transid: random(digits: 4), email: UserDefaultsManager.config.data?.settings?.email ?? "",
                                       zipCode: random(digits: 5),
                                       currency: "SAR",
                                       country: "SA",
                                       actionCode: "1",
                                       trackIdCode: random(digits: 8),
                                       udf4: isApplePayPaymentTrxn ? "ApplePay" : "",
                                       udf5: isApplePayPaymentTrxn ? paymentString : "", city: "Riyadh",
                                       address: "",
                                       createTokenIsEnabled: false,
                                       merchantIP: "223.178.209.68",
                                       cardToken: "",
                                       cardOper: "A",
                                       state: "",
                                       merchantidentifier: "merchant.com.selsela.abayasquaree",
                                       tokenizationType: "0")
        
        
        
        return model
    }
    
    func didPaymentResult(result: paymentResult, error: Error?, model: PaymentResultData?) {
        switch result {
        case .sucess:
            let request = ConfirmPaymentRequest(orderId: viewModel.addOrderResponse.order?.order?.id,
                                                paymentId: viewModel.addOrderResponse.order?.paymentId,
                                                paymentTypeId: viewModel.addOrderResponse.order?.order?.paymentType,
                                                applePayRefernce: model?.transID)
            confirmApplePayPayment(request: request)
        case .failure(_):
            DispatchQueue.main.async {
                self.router.dataSource?.errorMsg = model?.respMsg
                self.router.goToFalilure()
            }
 //           print("failure: \(error), resutl: \(result) , model: \(model?.respMsg) , \(model?.amount) , \(model?.responseCode)")
        case .mandatory(_): break
//            print("mandatory: \(result)")
        }
    }
}


//  MARK: - TAMARA PAYMENT GETWAY
extension PaymentMethodVC: TamaraCheckoutDelegate {

    func onSuccessfull() {
        self.removeSpinner()
        self.tamaraSDK.dismiss(animated: true) {
            UserDefaults.standard.setValue("Tamara", forKey: "Come")
            UserDefaults.standard.setValue("\(self.viewModel.addOrderResponse.order?.order?.id ?? 0)", forKey: "OrderID")
            UserDefaults.standard.setValue(self.orderidTamara, forKey: "TamaraOrderID")
            self.router.goToSuccess()
        }
//        self.updateTamara()
//            let request = AfterTamaraRequest(order_id: "\(self.viewModel.addOrderResponse.order?.order?.id ?? 0)", tamaraOrderId: self.orderidTamara)
//            self.viewModel.afterTamaraAPI(request: request) {result in
//                switch result {
//                case .success(let response): self.onSuccess(response)
//                case .failure(let error): self.onFailure(error)
//                }
//            }
            
//        }

    }
    
    func onFailured() {
        tamaraSDK.dismiss(animated: true) {
            self.router.goToFalilure()
        }
    }
    
    func onCancel() {
        tamaraSDK.dismiss(animated: true) {
            //cancel handel
        }
    }
    
    func onNotification() {
        tamaraSDK.dismiss(animated: true) {
            //notification handel
        }
    }
    
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
