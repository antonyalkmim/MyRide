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
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 7
        let number = driver.coordinate.latitude as NSNumber
        return formater.string(from: number) ?? ""
    }
    
    var longitudeFormatted: String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 7
        let number = driver.coordinate.longitude as NSNumber
        return formater.string(from: number) ?? ""
    }
    
    var distanceFormatted: String {
        let driverLocation = CLLocation(latitude: driver.coordinate.latitude,
                              longitude: driver.coordinate.longitude)
        
        let distanceKms = userLocation.distance(from: driverLocation) / 1000
        
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 1
        let number = distanceKms as NSNumber
        let distanceFormatted = formater.string(from: number) ?? "0"
        
        return "\(distanceFormatted) km"
    }
    
}

extension DriverCellViewModel: Equatable { }

func == (lhs: DriverCellViewModel, rhs: DriverCellViewModel) -> Bool {
    return lhs.driver.id == rhs.driver.id
}

extension DriverCellViewModel: IdentifiableType {
    typealias Identity = String
    
    var identity: DriverCellViewModel.Identity {
        return "\(identifier)#\(driverFleetType))"
    }
}
