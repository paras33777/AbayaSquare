//
//  NotificationsViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/6/21.
//

import Foundation
class NotificationsViewModel {
    
    var notifications: [Notifcations] = []
    
    func getNotifications(onComplete: @escaping onComplete<NotificationsModel.Response>){
        API.shared.startAPI(endPoint: .getNotifications, req: NotificationsModel.Request(), onComplete: onComplete)
    }
    
    func deleteNotificaton(request: NotificationsModel.DeleteNotification,onComplete: @escaping onComplete<NotificationsModel.Response>){
        API.shared.startAPI(endPoint: .deleteNotification, req: request, onComplete: onComplete)
    }
    
    func clearAllNotifications(onComplete: @escaping onComplete<NotificationsModel.Response>){
        API.shared.startAPI(endPoint: .clearNotifications, req: NotificationsModel.Request(), onComplete: onComplete)
    }
}


