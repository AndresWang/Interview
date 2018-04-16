//
//  Interactor.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
protocol InteractorDelegate: APIOutputDelegate {
    func configure()
}
class Interactor: InteractorDelegate {
    var api: APIDelegate!
    var searchRequest: SearchRequest?
    
    func configure() {
        self.api = WeatherAPI(output: self)
    }
    
    // MARK: - APIOutputDelegate
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error as NSError?, error.code == -999 {
            print("URLSession's task was cancelled -> Handled silently")
            return /* Exit */
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                process(data)
                return /* Exit */
            }
        } else {
            print("URLSession Failure! \(String(describing: response)) -> Passed to our error handler")
        }
        
        // Handle errors
        DispatchQueue.main.async {self.searchRequest?.errorHandler()}
    }
    
    // MARK: - Private Methods
    private func process(_ data: Data) {
        searchResponse = data.parseTo(jsonType: MoviedbAPI.JSON.Response.self)?.toMovie()
        DispatchQueue.main.async {self.searchRequest?.successHandler(searchText, self.isLoadMore)}
    }
}
