//
//  NotificationsModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/6/21.
//

import Foundation

enum NotificationsModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let notifcations: [Notifcations]?
    }
    
    struct DeleteNotification: Codable {
        let id: String?
    }
}

struct Notifcations: Codable {
    let id: String?
    let title: String?
    let message: String?
    let humanDate: String?
    let createdAt: String?
}
