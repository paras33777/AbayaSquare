//
//  Coder.swift
//  Sharwa
//
//  Created by Mohamed Zakout on 13/11/2020.
//

import Foundation

extension JSONEncoder {
    func with(encodingStrategy: KeyEncodingStrategy) -> JSONEncoder {
        keyEncodingStrategy = encodingStrategy
        return self
    }
}

extension JSONDecoder {
    func with(decodingStrategy: KeyDecodingStrategy) -> JSONDecoder {
        keyDecodingStrategy = decodingStrategy
        return self
    }
}
