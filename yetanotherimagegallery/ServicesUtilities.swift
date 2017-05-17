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
