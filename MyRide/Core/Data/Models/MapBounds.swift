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
