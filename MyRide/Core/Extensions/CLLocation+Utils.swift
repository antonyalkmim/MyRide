//
//  CLLocation+Utils.swift
//  MyRide
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    
    // swiftlint:disable identifier_name
    /// Calculate the center coordinate between two coordinates
    static func centerCoordinate(northEastCoordinate: CLLocationCoordinate2D,
                                 southWestCoordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1 = northEastCoordinate.longitude * .pi / 180
        let lon2 = southWestCoordinate.longitude * .pi / 180
        let lat1 = northEastCoordinate.latitude * .pi / 180
        let lat2 = southWestCoordinate.latitude * .pi / 180
        
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y))
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center = CLLocationCoordinate2D(latitude: lat3 * 180 / .pi,
                                            longitude: lon3 * 180 / .pi)
        return center
    }
    // swiftlint:enable identifier_name
}
