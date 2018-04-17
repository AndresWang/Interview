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
    
    // MARK: - Private Methods
    private func startDataTask(url: URL, forSearch: Bool) {
        dataTask?.cancel()
        
        // Start URLSession
        let session = URLSession.shared
        dataTask = session.dataTask(with: url) { data, response, error in
            self.output?.didRecieveResponse(data: data, response: response, error: error, forSearch: forSearch)
        }
        dataTask?.resume()
    }
    private func getUrl(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: domain + "q=%@" + apiKey, encodedText)
        return URL(string: searchTerm)!
    }
    private func getUrl(lat: Double, lon:  Double) -> URL {
        let searchTerm = String(format: domain + "lat=%f&lon=%f" + apiKey, lat, lon)
        return URL(string: searchTerm)!
    }
}
