//
//
//
//
//  Created by Mohamed Zakout.
//  Copyright © 2020 Mohamed Zakout. All rights reserved.
//

import Alamofire
import Kingfisher
class API {
    static let shared = API()
    
    private init() {}
    
    private let session = Alamofire.Session(interceptor: APIInterceptor())
    
    func startAPI<Request: Codable, Response: GenericResponse>(endPoint: EndPoints,
                                                               req: Request,
                                                               onComplete: @escaping onComplete<Response>) {
        
        if !NetworkReachability.shared.isConnected {
            onComplete(.failure(.noInternetConnection))
        }
        
        var headers: HTTPHeaders = ["language"   : MainHelper.shared.appLanguage(),
                                    "device_key" : AppDelegate.deviceKey]
        
        if let token = UserDefaultsManager.token {
            headers = [.authorization(bearerToken: token)]
        }
        let url = BASE_URL + endPoint.rawValue
//        if endPoint == .getMostSelling || endPoint == .getOffers {
//            url = BASE_URL_DEV + endPoint.rawValue
//        }
        session.request(url, method: endPoint.method, parameters: req.toDic(), encoding: endPoint.encoding, headers: headers).responseData { response in
            
            self.handleResponse(response, onComplete: onComplete)
        }
    }

    func handleResponse<T: GenericResponse>(_ response: AFDataResponse<Data>,
                                            onComplete: @escaping onComplete<T>) {
        
        print(response.debugDescription)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        if case let .success(data) = response.result {
            guard let model = T.decode(data) else {
                onComplete(.failure(.parseError))
                return
            }
            
            if model.status.falseIfNull {
                onComplete(.success(model))
            } else if let errors = model.errors, !errors.isEmpty {
                onComplete(.failure(.errors(errors)))
            } else {
                onComplete(.failure(.error(model.responseMessage.emptyIfNull)))
            }
        }
        
        if case let .failure(error) = response.result {
            onComplete(.failure(.AFError(error)))
        }
    }
    
    func startAPIMultiPart<Request: MutlipartRequest,
                               Response: GenericResponse>(endPoint: EndPoints,
                                                          req: Request,
                                                          onComplete: @escaping onComplete<Response>){
    
        
        guard NetworkReachability.shared.isConnected else {
            onComplete(.failure(APIError.noInternetConnection))
            return
        }
        
        let parameters = req.toDic()
        
        var headers: HTTPHeaders = ["language" : MainHelper.shared.appLanguage()]
        if let token = UserDefaultsManager.token {
            headers["Authorization"] = "Bearer " + token
        }
        
        AF.upload(multipartFormData: {multipartFormData in
            for (key, value) in parameters {
                if let base = value as? String, let value = Data(base64Encoded: base), req.files.map(\.toSnakCase).contains(key) {
                    multipartFormData.append(value, withName: key, fileName: "\(key).png", mimeType: "image/png")
                } else {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
        },to: BASE_URL + endPoint.rawValue ,usingThreshold: UInt64.init() ,method: .post, headers: headers).responseData{
            self.handleResponse($0, onComplete: onComplete)
        }
    }
    
    func cancelRequests() {
        session.cancelAllRequests()
    }
    
}


protocol MutlipartRequest: Codable {
    var files: [String] { get set }
}
