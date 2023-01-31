//
//  Decodable.swift
//  RetailERPProject
//
//  Created by Mohamed Zakout on 7/17/20.
//  Copyright © 2020 Selsela. All rights reserved.
//

import Foundation

protocol GenericResponse: Codable {
    var status: Bool? { get set }
    var responseMessage: String? { get set }
    var errors: [ResponseError]? { get set }
    
}

extension Decodable {
    static func decode(_ data: Data) -> Self? {
        do {
            return try JSONDecoder().with(decodingStrategy: .convertFromSnakeCase).decode(self, from: data)
        } catch {
            print("Failed To Parse Model: \(error)")
            return nil
        }
    }
}

extension Encodable {
    func encode() -> Data? {
        return try? JSONEncoder().with(encodingStrategy: .convertToSnakeCase).encode(self)
    }
    
    func toDic() -> [String : Any] {
        if let data = encode(), let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            return json as! [String : Any]
        }
        return [:]
    }
}
