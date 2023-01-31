//
//  AboutViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/1/21.
//

import Foundation

class AboutViewModel {
    func getAppContent(onComplete: @escaping onComplete<AboutModel.Response>){
        API.shared.startAPI(endPoint: .getappContent, req: AboutModel.Request(), onComplete: onComplete)
    }
}
