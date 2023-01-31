//
//
//
//
//  Created by Mohamed Zakout.
//  Copyright © 2020 Mohamed Zakout. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case failure(APIError)
}
