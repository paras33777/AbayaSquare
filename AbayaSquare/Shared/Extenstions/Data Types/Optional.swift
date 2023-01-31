//
//  Optional.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/3/21.
//

import Foundation

extension Optional where Wrapped == Double {
    var zeroIfNull: Double {
        return self ?? 0.0
    }
}

extension Optional where Wrapped == Bool {
    var falseIfNull: Bool {
        return self ?? false
    }
}

extension Optional where Wrapped == String {
    var emptyIfNull: String {
        return self ?? ""
    }
}

extension Optional where Wrapped == [IndexPath] {
    var emptyIfNull: [IndexPath] {
        return self ?? []
    }
}
extension Optional where Wrapped == Int {
    var zeroIfNull: Int {
        return self ?? 0
    }
}
