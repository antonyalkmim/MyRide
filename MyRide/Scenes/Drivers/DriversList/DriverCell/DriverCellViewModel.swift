//
//  DriverCellViewModel.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import RxDataSources
import CoreLocation

struct DriverCellViewModel {
    
    let driver: Driver
    let userLocation: CLLocation
    
    var identifier: String {
        return "#\(driver.id)"
    }
    
    var driverFleetType: String {
        return "\(driver.fleetType)".capitalized
    }
    
    var latitudeFormatted: String {
        let number = driver.coordinate.latitude as NSNumber
        return NumberFormatter.coordinateFormatter.string(from: number) ?? ""
    }
    
    var longitudeFormatted: String {
        let number = driver.coordinate.longitude as NSNumber
        return NumberFormatter.coordinateFormatter.string(from: number) ?? ""
    }
    
    var distanceFormatted: String {
        let driverLocation = CLLocation(latitude: driver.coordinate.latitude,
                                        longitude: driver.coordinate.longitude)
        
        // distance in meters divided by 1000 to show in kilometers
        let distanceKms = userLocation.distance(from: driverLocation) / 1000
        
        let formatter = NumberFormatter.killometersDistanceFormatter
        let distanceFormatted = formatter.string(from: distanceKms as NSNumber) ?? "0"
        
        return "\(distanceFormatted) km"
    }
    
    var driverIcon: UIImage {
        switch driver.fleetType {
        case .taxi:
            return Asset.taxiMap.image
        case .pooling:
            return Asset.poolingMap.image
        }
    }
    
}

extension DriverCellViewModel: Equatable { }

func == (lhs: DriverCellViewModel, rhs: DriverCellViewModel) -> Bool {
    return lhs.driver.id == rhs.driver.id && lhs.userLocation == rhs.userLocation
}

// needs for RxDataSource Differentiator
extension DriverCellViewModel: IdentifiableType {
    typealias Identity = String
    
    var identity: DriverCellViewModel.Identity {
        return "\(identifier)#\(driverFleetType))"
    }
}
