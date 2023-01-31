//
//
//
//
//  Created by Mohamed Zakout.
//  Copyright © 2020 Mohamed Zakout. All rights reserved.
//

import Alamofire

class APIInterceptor: RequestInterceptor {
    
    //    let requestsFor: [EndPoints] = []
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.retryWithDelay(2))
    }
}


extension String {
    func contains(_ endPoint: EndPoints) -> Bool {
        return self.contains(endPoint.rawValue)
    }
}
