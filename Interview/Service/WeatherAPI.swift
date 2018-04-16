//
//  WeatherAPI.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

class WeatherAPI {
    weak var output: APIOutputDelegate?
    var dataTask: URLSessionDataTask?
    
    init(output: APIOutputDelegate) {
        self.output = output
    }
    
    // MARK: - JSON
    struct JSON {
        struct Response: Codable {
            var coord: [String: Double]
            var weather: [WeatherInfo]
            var base: String
            var main: [String: Double]
            var visibility: Int
            var wind: [String: Double]
            var name: String
            func toWeather() -> Weather {
                return Weather(description: weather.first!.description, visibility: visibility, wind: wind, name: name)
            }
        }
        
        struct WeatherInfo: Codable {
            var id: Int
            var main: String
            var description: String
            var icon: String
        }
    }
    
    // MARK: - Helper Methods
    static func searchURL(with text: String) -> URL {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: "https://api.openweathermap.org/data/2.5/weather?q=%@&APPID=ceb0d466055ae9ce11e993747afcc3a6", encodedText)
        return URL(string: searchTerm)!
    }
}
