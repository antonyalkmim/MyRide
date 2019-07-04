//
//  DriverAnnotationViewModel.swift
//  MyRide
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers class DriverAnnotationViewModel: NSObject {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: driver.coordinate.latitude,
                                      longitude: driver.coordinate.longitude)
    }
    
    var title: String { return "\(driver.fleetType)".capitalized }
    
    var subtitle: String {
        let driverLocation = CLLocation(latitude: driver.coordinate.latitude,
                                        longitude: driver.coordinate.longitude)
        
        // distance in meters divided by 1000 to show in kilometers
        let distanceKms = userLocation.distance(from: driverLocation) / 1000
        
        let formater = NumberFormatter.killometersDistanceFormatter
        let distanceFormatted = formater.string(from: distanceKms as NSNumber) ?? "0"
        
        return "\(distanceFormatted) km"
    }
    
    var pinImage: UIImage {
        switch driver.fleetType {
        case .taxi:
            return Asset.taxiMap.image
        case .pooling:
            return Asset.poolingMap.image
        }
    }
    
    // MARK: - Private
    
    let driver: Driver
    let userLocation: CLLocation
    
    init(driver: Driver, userLocation: CLLocation) {
        self.driver = driver
        self.userLocation = userLocation
    }
}
