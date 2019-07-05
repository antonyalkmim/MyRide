//
//  MapBounds.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers public class MapBounds: NSObject {
    
    let northEastCoordinate: CLLocationCoordinate2D
    let southWestCoortinate: CLLocationCoordinate2D
    
    public init(northEastCoordinate: CLLocationCoordinate2D,
                southWestCoortinate: CLLocationCoordinate2D) {
        self.northEastCoordinate = northEastCoordinate
        self.southWestCoortinate = southWestCoortinate
    }
}

extension MapBounds {
    
    var centerCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.centerCoordinate(northEastCoordinate: northEastCoordinate,
                                                       southWestCoordinate: southWestCoortinate)
    }
    
    // Hamburg Bounds
    class var hamburgBounds: MapBounds {
        let neCoordinate = CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589)
        let swCoordinate = CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891)
        
        return MapBounds(northEastCoordinate: neCoordinate, southWestCoortinate: swCoordinate)
    }
}
