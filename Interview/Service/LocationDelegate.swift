//
//  LocationDelegate.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreLocation

typealias ShouldPresentDeniedAlert = Bool
protocol LocationDelegate: class, CLLocationManagerDelegate {
    func startLocationService() -> ShouldPresentDeniedAlert
}
protocol LocationOutputDelegate: class {
    func didGetLocation(location: CLLocation)
    func didFailToGetLocation(error: NSError)
}

extension LocationService: LocationDelegate {
    // MARK: - Boundary Methods
    func startLocationService() -> ShouldPresentDeniedAlert {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization(); return false
        case .denied, .restricted:
            return true
        default:
            break
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        return false
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Failure: \(error)")
        guard (error as NSError).code != CLError.locationUnknown.rawValue else {return}
        
        stopLocationManager()
        output?.didFailToGetLocation(error: error as NSError)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        output?.didGetLocation(location: newLocation)
    }
    private func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}
