//
//  ServicesUtilities.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import JASON
import Alamofire

enum ServiceResult<T> {
    case success(T)
    case failure(error: String)
}


extension DataRequest {
    enum CustomError: Error {
        case networkError(error: Error?)
        case failure(error: Error?)
    }
    
    static func jsonResponseSerializer() -> DataResponseSerializer<JSON> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(CustomError.networkError(error: error))
            }
            
            let result = Request.serializeResponseData(response: response,
                                                       data: data, error: nil)
            
            guard case .success = result else {
                return .failure(CustomError.failure(error: result.error))
            }
            
            return .success(JSON(result.value))
        }
    }
    
    @discardableResult
    func responseCustomJSON(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {
        return validate(statusCode: 200..<300)
            .response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(),
                      completionHandler: completionHandler)
    }
}
