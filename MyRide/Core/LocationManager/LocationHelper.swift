//
//  LocationHelper.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static var shared = LocationHelper()
    
    typealias CurrentLocationCallback = ((CLLocation) -> Void)
    
    private var didGetCurrentLocation: CurrentLocationCallback?
    
    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    override init() {
        super.init()
    }
    
    func getCurrentLocation(completion: @escaping CurrentLocationCallback) {
        self.didGetCurrentLocation = completion
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            didGetCurrentLocation?(location)
        }
        // capture user location only once
        manager.stopUpdatingLocation()
    }
    
}
