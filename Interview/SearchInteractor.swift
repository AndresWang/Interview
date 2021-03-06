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
    var currentWeather: Weather? {get}
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
    var currentWeather: Weather?
    
    func configure() {
        self.api = WeatherAPI(output: self)
        self.location = LocationService(output: self)
        self.dataStore = CoreDataStore.sharedInstance
    }
    func search(request: SearchRequest) {
        self.searchRequest = request
        api.startFetchData(searchText: request.text)
    }
    func saveSuccessfulQuery(searchText: String) {
        dataStore.saveSuccessfulQuery(text: searchText)
    }
    func startLocationService(request: LocationRequest) -> ShouldPresentDeniedAlert {
        self.locationRequest = request
        return location.startLocationService()
    }
    
    // MARK: - APIOutputDelegate
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?, forSearch: Bool) {
        if let error = error as NSError?, error.code == -999 {
            print("URLSession's task was cancelled -> Handled silently")
            return /* Exit */
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                if forSearch {
                    processSearchResult(data)
                } else {
                    processCurrentWeather(data)
                }
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
        api.startFetchData(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
        locationRequest?.successHandler()
    }
    func didFailToGetLocation(error: NSError) {
        locationRequest?.errorHandler()
    }
    
    // MARK: - Private Methods
    private func processSearchResult(_ data: Data) {
        result = data.parseTo(jsonType: WeatherAPI.JSON.Response.self)?.toWeather()
        let searchText = result != nil ? searchRequest?.text : nil
        DispatchQueue.main.async {self.searchRequest?.successHandler(searchText)}
    }
    private func processCurrentWeather(_ data: Data) {
        currentWeather = data.parseTo(jsonType: WeatherAPI.JSON.Response.self)?.toWeather()
        DispatchQueue.main.async {self.locationRequest?.successHandler()}
    }
}
