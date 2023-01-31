//
//  GMSResponse.swift
//  Manasa Restaurant
//
//  Created by Mohamed Zakout on 11/11/2020.
//  Copyright © 2020 com.selsela. All rights reserved.
//

import Foundation

struct GMSResponse: Codable {
    var results: [GMSResult]
    
    func get(_ addressType: AddressType) -> String? {
        for result in results {
            for component in result.addressComponents {
                if component.types.contains(addressType.rawValue) {
                    return component.longName
                }
            }
        }
        return nil
    }
    
    static func decode(_ data: Data) -> GMSResponse? {
        do {
            return try JSONDecoder().with(decodingStrategy: .convertFromSnakeCase).decode(GMSResponse.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}

struct GMSResult: Codable {
    var addressComponents: [AddressComponent]
    var formattedAddress: String
}

struct AddressComponent: Codable {
    var longName: String
    var shortName: String
    var types: [String]
}

enum AddressType: String, Codable {
    case streetNumber = "street_number"
    case areaLevel1 = "administrative_area_level_1"
    case areaLevel2 = "administrative_area_level_2"
    case country = "country"
    case locality = "locality"
    case sublocality = "sublocality"
    case block = "neighborhood"
    case streetName = "route"
    case political = "political"
//    case postalCode = "postal_code"
   case sublocalityLevel1 = "sublocality_level_1"
//    case establishment = "establishment"
}
