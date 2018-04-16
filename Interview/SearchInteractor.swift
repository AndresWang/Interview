//
//  Interactor.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
protocol SearchInteractorDelegate: APIOutputDelegate {
    var results: [Weather] {get}
    func configure()
    func search(request: SearchRequest)
    func saveSuccessfulQuery(searchText: String)
}
class SearchInteractor: SearchInteractorDelegate {
    var api: APIDelegate!
    var dataStore: DataStoreDelegate!
    var searchRequest: SearchRequest?
    var results: [Weather] = []
    
    func configure() {
        self.api = WeatherAPI(output: self)
        self.dataStore = CoreDataStore.sharedInstance
    }
    func search(request: SearchRequest) {
        self.searchRequest = request
        let url = WeatherAPI.searchURL(with: request.text)
        api.startDataTask(url: url)
    }
    func saveSuccessfulQuery(searchText: String) {
        dataStore.saveSuccessfulQuery(text: searchText)
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
        results = data.parseTo(jsonType: WeatherAPI.JSON.Response.self)?.toWeather()
        let searchText = results.count > 0 ? searchRequest?.text : nil
        DispatchQueue.main.async {self.searchRequest?.successHandler(searchText)}
    }
}
