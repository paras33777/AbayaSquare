//
//  SuccessVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/26/21.
//

import UIKit

class SuccessVC: UIViewController {

    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var successLB: UILabel!
    @IBOutlet weak var subTitleLB: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var vcCase: SuccessVCCases = .Success
    var isPaymentCash: Int = 0
    var errorMsg = ""
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "Come") == "Tamara"{
            updateTamara()
//            print("*********\(UserDefaults.standard.string(forKey: "OrderID"))")
//            print("*********\(UserDefaults.standard.string(forKey: "TamaraOrderID"))")

        }else{
            setup()

        }
    }
    func updateTamara(){

        let parameters = [
          [
            "key": "order_id",
            "value": UserDefaults.standard.string(forKey: "OrderID"),
            "type": "text"
          ],
          [
            "key": "tamaraOrderId",
            "value": UserDefaults.standard.string(forKey: "TamaraOrderID"),//self.orderidTamara,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
                let fileData = (try? NSData(contentsOfFile:paramSrc, options:[]) as Data)!
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        let token = UserDefaultsManager.token ?? ""
        var request = URLRequest(url: URL(string: "https://abayasquare.com/api/v1/customer/order/update-tamara")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
   //       print(String(data: data, encoding: .utf8)!)
            
            let str = (String(data: data, encoding: .utf8)!)
            let message = str.decoded
//            print(message)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self.setup()
            }
        }

        task.resume()
    }
    @IBAction func backToHome(_ sender: Any) {
        switch vcCase {
        case .Success:
            tabBarController?.selectedIndex = 2
            navigationController?.popToRootViewController(animated: true)
        case .Failure:
            navigationController?.popViewControllers(viewsToPop: 2)
        }
    }
    
    func setup(){
        
        print("isPaymentCash: \(isPaymentCash)")
        
        switch vcCase {
        case .Success:
            successImage.image = UIImage(named: "ic_success")
            successLB.text = "Success!".localized
            if isPaymentCash == 1 {
                subTitleLB.text = "Your Order has been received Successfully!".localized
            } else {
                subTitleLB.text = "We have successfully received your payment. Thank you!".localized
            }
            backButton.setTitle("Back to Home".localized, for: .normal)
        case .Failure:
            successImage.image = UIImage(named: "ic_failed")
            successLB.text = "Oh Snap!".localized
            successLB.textColor = UIColor("#EB5252")
            view.backgroundColor = UIColor("#FFEAED")
            subTitleLB.text = "The transaction couldn't be made. Please retry".localized
            backButton.setTitle("Retry".localized, for: .normal)
            backButton.backgroundColor = UIColor("#EB5252")
        }
    }
}


enum SuccessVCCases{
    case Success
    case Failure
}
