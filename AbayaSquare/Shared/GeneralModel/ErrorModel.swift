//
//  ErrorModel.swift
//  Drawel
//
//  Created by Ayman  on 10/5/20.
//  Copyright © 2020 Ayman . All rights reserved.
//

import Foundation

struct ResponseError: Codable {
    let field: String
    let error: String
}
