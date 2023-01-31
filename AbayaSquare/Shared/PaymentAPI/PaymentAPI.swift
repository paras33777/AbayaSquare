//
//  PaymentAPI.swift
//  AbayaSquare
//
//  Created by Ayman AbuMutair on 16/11/2021.
//

import Foundation
import Alamofire

class PaymentAPI {
    
    static let shared = PaymentAPI()
    
    private init() {}
    
    private let session = Alamofire.Session(interceptor: APIInterceptor())
    
    func startAPITabby<Request: Codable, Response: Codable>(endPoint: String,
                                                               req: Request,
                                                               headers: HTTPHeaders,
                                                               onComplete: @escaping onComplete<Response>) {
        guard NetworkReachability.shared.isConnected else {
            onComplete(.failure(.noInternetConnection))
            return
        }
        
        session.request(endPoint, method: .post, parameters: req.toDic(), encoding: JSONEncoding.default, headers: headers).responseData { response in
            self.handleTabbyResponse(response, onComplete: onComplete)
        }
    }
    
    func handleTabbyResponse<T: Codable>(_ response: AFDataResponse<Data>,
                                            onComplete: @escaping onComplete<T>) {
        print(response.debugDescription)
        let statusCode = response.response?.statusCode ?? 0
        
        guard let data = response.data else {
            onComplete(.failure(.unKnownError))
            return
        }
        
        guard let model = T.decode(data) else {
            onComplete(.failure(.parseError))
            return
        }
        
        if statusCode == 200 || statusCode == 422 || statusCode == 400 {
            switch response.result {
            case .success(_):
                onComplete(.success(model))
            case .failure(let error):
                error._code ==  NSURLErrorTimedOut ? onComplete(.failure(.timeOut)) : onComplete(.failure(.AFError(error)))
            }
        }
        
        if case let .failure(error) = response.result {
            onComplete(.failure(.AFError(error)))
        }
    }
    
}
