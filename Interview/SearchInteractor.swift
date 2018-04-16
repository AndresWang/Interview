//
//  Interactor.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreLocation

protocol SearchInteractorDelegate: APIOutputDelegate, LocationOutputDelegate {
    var result: Weather? {get}
    func configure()
    func search(request: SearchRequest)
    func saveSuccessfulQuery(searchText: String)
    func startLocationService(request: LocationRequest) -> ShouldPresentDeniedAlert
}
class SearchInteractor: SearchInteractorDelegate {
    var api: APIDelegate!
    var location: LocationDelegate!
    var dataStore: DataStoreDelegate!
    var searchRequest: SearchRequest?
    var locationRequest: LocationRequest?
    var result: Weather?
    
    func configure() {
        self.api = WeatherAPI(output: self)
        self.location = LocationService(output: self)
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
    func startLocationService(request: LocationRequest) -> ShouldPresentDeniedAlert {
        self.locationRequest = request
        return location.startLocationService()
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
    
    // MARK: - LocationOutputDelegate
    func didGetLocation(location: CLLocation) {
        self.locationRequest?.successHandler(location)
    }
    func didFailToGetLocation(error: NSError) {
        self.locationRequest?.errorHandler(error)
    }
    
    // MARK: - Private Methods
    private func process(_ data: Data) {
        result = data.parseTo(jsonType: WeatherAPI.JSON.Response.self)?.toWeather()
        let searchText = result != nil ? searchRequest?.text : nil
        DispatchQueue.main.async {self.searchRequest?.successHandler(searchText)}
    }
}
