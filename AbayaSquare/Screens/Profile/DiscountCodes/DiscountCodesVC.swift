//
//  DiscountCodesVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

protocol DiscountCodesDelegate {
    func didSelectCoupon(coupon: Offer)
}

class DiscountCodesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    let viewModel = DiscountCodesViewModel()
    var delegate: DiscountCodesDelegate?
    var discountList: DiscountModelClass?
    let viewModel1 = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Discount Coupons".localized
        setupRefreshControl()
        getCoupons()
        showCoupon.removeAll()
    }
}

extension DiscountCodesVC{
    func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .black
        tableView.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func getCoupons(){
        tableView.showSpinner(spinnerColor: .black,backgroundColor: UIColor("#F1F3F6"))
        startAPI()
    }
    
    @objc func startAPI() {
        viewModel.getDiscountCodes() {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: DiscountCodesModel.Response){
//        if showCoupon.contains(1){
            viewModel.coupons = response.appContents ?? []
//        }else{
//
//        }

        viewModel.coupons.removeAll{$0.countOfUse == 0}
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        removeSpinner()
        checkEmpty()
    }
    
    func checkEmpty(){
        viewModel.coupons.isEmpty ? (emptyView.isHidden = false ) : (emptyView.isHidden = true)
    }
    func postRequest() {

      // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid

    }
}

extension DiscountCodesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCodeCell", for: indexPath) as! DiscountCodeCell
        let model = viewModel.coupons[indexPath.row]
        cell.config(with: model)
        cell.delegate = self
        return cell
    }
}

extension DiscountCodesVC: DiscountCodeCellDelegate {
    func couponApplied(cell: DiscountCodeCell) {
        if let row = tableView.indexPath(for: cell)?.row {
            
            let originalString = totalAmount
            let numberString = originalString.filter({ "1234567890.".contains($0) })
//            print(numberString)
            let parameters: [String: Any] = ["code": viewModel.coupons[row].code ?? "", "total": numberString ,"products": productAllListId]

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
//              print("Post Request Error: \(error.localizedDescription)")
              return
            }

            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
                  
            else {
           DispatchQueue.main.async {
            do{
               let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
//                print(json!)
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
                          UserDefaultsManager.isDiscountCodeApplied = true
                          UserDefaultsManager.coupon = self.discountList?.coupon
//                          print(jsonResponse)
                          self.navigationController?.popViewController(animated: true)

                      }catch{
//                         print("ERROR!")
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
        
            
//            var id = 0
//            id = Int(CoreDataManager.getDesigners().first {$0 == viewModel.coupons[row].designer?.id ?? 0} ?? 0)
//            if id == viewModel.coupons[row].designer?.id {
//                if CoreDataManager.isCouponIsUsedBefore(couponId: viewModel.coupons[row].id) {
//                    MainHelper.shared.showErrorMessage(responseMessage: "you Can Use the only one time".localized)
//                } else {
//                    CoreDataManager.insert(coupon: viewModel.coupons[row])
//                    delegate?.didSelectCoupon(coupon: viewModel.coupons[row])
//                    navigationController?.popViewController(animated: true)
//                    let designerId = viewModel.coupons[row].designer?.id.int16 ?? 0
//                    let codeId = viewModel.coupons[row].id.int16
//                    let couponRatio = viewModel.coupons[row].discountRatio.zeroIfNull
//                    let code = viewModel.coupons[row].code.emptyIfNull
//                    CoreDataManager.updateProduct(designerId: designerId, couponId: codeId, couponRatio: couponRatio, couponCode: code)
//                    UserDefaultsManager.isDiscountCodeApplied = true
//                    MainHelper.shared.showSuccessMessage(responseMessage: "Discount Code has been applied to all the products in the cart from the designer".localized)
//                }
//            } else {
//                MainHelper.shared.showErrorMessage(responseMessage: "You can't apply this code on the produts in cart".localized)
//            }
        }
    }
//}
