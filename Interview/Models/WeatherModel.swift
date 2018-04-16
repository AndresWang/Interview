//
//  WeatherModel.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: Our own data model separated from api model just in case​ ​we​ ​are​ ​asked​ ​to​ ​change​ ​to​ ​xml-based​ ​api​ ​instead​ ​of​ ​json, separation of concerns.
struct Weather {
    var description: String
    var visibility: Int
    var wind: [String: Double]
    var name: String
}
