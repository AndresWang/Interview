//
//  Location.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    let locationManager = CLLocationManager()
    var updatingLocation = false
    weak var output: LocationOutputDelegate?
    
    init(output: LocationOutputDelegate) {
        self.output = output
        super.init()
    }
}
