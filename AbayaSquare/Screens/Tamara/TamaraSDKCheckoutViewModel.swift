//
//  TamaraSDKCheckoutViewModel.swift
//  AbayaSquare
//
//  Created by Pratibha on 22/09/22.
//

import Foundation

import Foundation
import TamaraSDK


public class TamaraSDKCheckoutViewModel: ObservableObject {
    
    @Published public var url: String
    @Published public var merchantURL: TamaraMerchantURL
    
    
    public init(url: String? = "", merchantURL: TamaraMerchantURL = TamaraMerchantURL(success: "", failure: "", cancel: "", notification: "")) {
        self.url = url ?? ""
        self.merchantURL = merchantURL
    }
}
