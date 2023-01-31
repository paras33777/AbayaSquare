//
//  PaymentWebViewVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 7/1/21.
//

import UIKit
import WebKit
class PaymentWebViewVC: UIViewController {
    
    
    @IBOutlet var webView: WKWebView!
    
    var transaction: String?
    
    var viewModel = PaymentMethodViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment Details".localized
        setupWebView()
    }
    
    private func setupWebView(){
        if let redirect_url = transaction , let url = URL(string: redirect_url ){
            let url_request = URLRequest(url: url)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.load(url_request)
        }
    }
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.userContentController.add(self, name: "tabbyMobileSDK")
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        view = webView
    }
    
    func addOrder(){
        viewModel.addOrder() {[self]result in
            switch result {
            case .success(let response): print(response)
            case .failure(let error): onFailure(error)
            }
        }
    }
    
    func capturePayment(){
        let id = viewModel.tabbyPaymentResponse?.payment?.id ?? ""
        let request = CaptureTabbyPaymentRequest(id: id,
                                                 amount: viewModel.tabbyPaymentResponse?.payment?.amount,
                                                 taxAmount: "0",
                                                 shippingAmount: viewModel.tabbyPaymentResponse?.payment?.order?.shippingAmount,
                                                 discountAmount: "0",
                                                 createdAt: viewModel.tabbyPaymentResponse?.payment?.createdAt)
        viewModel.captureTabbyPayment(request: request, paymentId: id) {_ in}
    }
    
    func confirmPayment(request: ConfirmPaymentRequest) {
        viewModel.confirmPayment(request: request) {[self] result in
            switch result {
            case .success(_) : confirmPaymentSuccess()
            case .failure(let error): onFailureConfirmPayment(error)
            }
        }
    }
    
    func confirmPaymentSuccess(){
        CoreDataManager.emptyBasket()
        NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
        let vc = storyboard?.instantiateViewController(identifier: "SuccessVC") as! SuccessVC
        vc.vcCase = .Success
        capturePayment()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onFailureConfirmPayment(_ error: APIError) {
        let vc = storyboard?.instantiateViewController(identifier: "SuccessVC") as! SuccessVC
        vc.vcCase = .Failure
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PaymentWebViewVC: WKNavigationDelegate , WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        if  let response_ = navigationResponse.response as? HTTPURLResponse , let url = response_.url{
            let vc = storyboard?.instantiateViewController(identifier: "SuccessVC") as! SuccessVC
            if ((url.absoluteString).contains("\(BASE_URL)") && (url.absoluteString).contains("Result=Successful")) {
                vc.vcCase = .Success
                navigationController?.pushViewController(vc, animated: true)
                CoreDataManager.emptyBasket()
                NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
            }else if ((url.absoluteString).contains("\(BASE_URL)")  && (url.absoluteString).contains("Result=Failure")) {
                vc.vcCase = .Failure
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaymentWebViewVC: WKScriptMessageHandler, WKScriptMessageHandlerWithReply {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let msg = message.body as? String else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        DispatchQueue.main.async {
            
            let parsedMessage = msg.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            switch parsedMessage {
            case "close": print("")
            case "authorized":
                let request = ConfirmPaymentRequest(orderId: self.viewModel.addOrderResponse.order?.order?.id,
                                                    paymentId: self.viewModel.addOrderResponse.order?.paymentId,
                                                    paymentTypeId: self.viewModel.addOrderResponse.order?.order?.paymentType,
                                                    applePayRefernce: self.viewModel.tabbyPaymentResponse?.payment?.id)
                print("request: \(request)")
                
                self.confirmPayment(request: request)
               
                break
            case "rejected":
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                    self.navigationController?.popViewController(animated: true)
                }
                break
            default:
                break
            }
        }

        
    }
    
func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
    //
}
}

