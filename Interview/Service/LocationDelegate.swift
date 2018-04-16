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
        
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        location = newLocation
        updateLabels()
    }
    private func stopLocationManager() {
        guard updatingLocation else {return}
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        updatingLocation = false
    }
    private func updateLabels() {
        guard let location = self.location else {return}
        let latitudeText = String(format: "%.8f", location.coordinate.latitude)
        let longitudeText = String(format: "%.8f", location.coordinate.longitude)
        print(latitudeText, longitudeText)
    }
}
