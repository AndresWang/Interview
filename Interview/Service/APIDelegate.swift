//
//  APIDelegate.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: Protocol interface for api communication just in case we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​api​.
protocol APIDelegate: class {
    var output: APIOutputDelegate? {get}
    var dataTask: URLSessionDataTask? {get}
    func startFetchData(searchText: String)
    func startFetchData(lon: Double, lat: Double)
}

// Note: For asynchronous network purpose, and in this case its output is our Interactor.
protocol APIOutputDelegate: class {
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?, forSearch: Bool)
}

// Note: WeatherdAPI as our APIDelegate
extension WeatherAPI: APIDelegate {
    func startFetchData(searchText: String) {
        let url = getUrl(searchText: searchText)
        startDataTask(url: url, forSearch: true)
    }
    func startFetchData(lon: Double, lat: Double) {
        let url = getUrl(lat: lat, lon: lon)
        startDataTask(url: url, forSearch: false)
    }
    
    private func startDataTask(url: URL, forSearch: Bool) {
        dataTask?.cancel()
        
        // Start URLSession
        let session = URLSession.shared
        dataTask = session.dataTask(with: url) { data, response, error in
            self.output?.didRecieveResponse(data: data, response: response, error: error, forSearch: forSearch)
        }
        dataTask?.resume()
    }
}
