//
//
//
//
//  Created by Mohamed Zakout.
//  Copyright © 2020 Mohamed Zakout. All rights reserved.
//

import Alamofire

enum APIError: Error {
    case noInternetConnection
    case unKnownError
    case parseError
    case timeOut
    case error(String)
    case AFError(AFError)
    case errors([ResponseError])
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection  : return NSLocalizedString("No Internet Connection, Please try again.".localized, comment: "")
        case .unKnownError          : return NSLocalizedString("Error Occured, Please try again.".localized, comment: "")
        case .parseError            : return NSLocalizedString("Parsing Error.".localized, comment: "")
        case .timeOut               : return NSLocalizedString("Request Time Out.".localized, comment: "")
        case .error(let error)      : return NSLocalizedString(error, comment: "")
        case .AFError(let error)    : return NSLocalizedString(error.errorDescription ?? "" , comment: "")
        case .errors(let errors):
            return NSLocalizedString(errors[0].error, comment: "")
        }
    }
}

