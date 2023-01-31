//
//  UserModel.swift
//  Drawel
//
//  Created by Ayman  on 10/5/20.
//  Copyright © 2020 Ayman . All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    let name: String?
    let mobile, token: String?
    let avatarUrl, avatarThumbUrl: String?
    var status: Int?
    let email: String?
    let addresses: [Address]?
    let wallet: Double?
    let points: Double?
    let promoCode: String?
    let activationCode: Int?
    let pointsValue: Double?
    
    func data() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func getUser(_ data: Data) -> User? {
        return try? JSONDecoder().decode(self, from: data)
    }
    
    static var currentUser: User? {
        get {
            if let unarchivedUser = UserDefaults.standard.object(forKey: "currentUser") as? NSData,
               let userData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedUser as Data) as? Data {
                return User.getUser(userData)
            }
            return nil
        }
        
        set {
            if let userData = newValue?.data(),
               let archivedUser = try? NSKeyedArchiver.archivedData(withRootObject: userData, requiringSecureCoding: false) {
                UserDefaults.standard.set(archivedUser, forKey: "currentUser")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
        }
    }
    
    static var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    static var isActivated: Bool {
        return currentUser?.status != 0
    }
}

struct Address: Codable {
    let id: Int
    let name: String?
    let mobile: String?
    let address: String?
    let type: String?
    let lat, lng: Double?
    let isInternal: Int?
    let area: City?
//isCash:
}
