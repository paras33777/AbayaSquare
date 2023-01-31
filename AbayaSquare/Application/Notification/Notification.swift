//
//  Notification.swift
//  GramApp
//
//  Created by Ayman  on 2/16/21.
//

import UIKit

extension Notification.Name {
    static let UserDidLogged = Notification.Name("UserDidLogged")
    static let UserDidLogout = Notification.Name("UserDidLogout")
    static let UserDidUpdateProfile = Notification.Name("UserDidUpdateProfile")
    static let ConfigDidSuccess = Notification.Name("ConfigDidSuccess")
    static let UserDidAddToFavorite = Notification.Name("UserDidAddToFavorite")
    static let DidRemoveFavorite = Notification.Name("DidRemoveFavorite")
    static let ShowAll = Notification.Name("ShowAll")
    static let ShowHighestPrice = Notification.Name("ShowHighestPrice")
    static let ShowLowestPrice = Notification.Name("ShowLowestPrice")
    static let UserDidAddProduct = Notification.Name("UserDidAddProduct")
    static let didChangeLanguage = Notification.Name("didChangeLanguage")
    static let diddeleteAccount = Notification.Name("didDeleteAccount")
}
