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
    func startDataTask(url: URL)
}

// Note: For asynchronous network purpose, and in this case its output is our Interactor.
protocol APIOutputDelegate: class {
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?)
}

// Note: WeatherdAPI as our APIDelegate
extension WeatherAPI: APIDelegate {
    func startDataTask(url: URL) {
        dataTask?.cancel()
        
        // Start URLSession
        let session = URLSession.shared
        dataTask = session.dataTask(with: url) { data, response, error in
            self.output?.didRecieveResponse(data: data, response: response, error: error)
        }
        dataTask?.resume()
    }
}
