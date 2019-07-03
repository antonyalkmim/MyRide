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
    let p1: CLLocationCoordinate2D
    let p2: CLLocationCoordinate2D
    
    public init(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) {
        self.p1 = p1
        self.p2 = p2
    }
}
