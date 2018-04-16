//
//  Requests.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreLocation

struct SearchRequest {
    var text: String
    var successHandler: (String?) -> Void
    var errorHandler: () -> Void
}
struct LocationRequest {
    var successHandler: (CLLocation) -> Void
    var errorHandler: (NSError) -> Void
}
