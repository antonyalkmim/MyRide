//
//  Driver.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

@objc public class Driver: NSObject, Decodable {
    @objc let id: UInt32
    @objc let heading: Double
    @objc let coordinate: Coordinate
    
    let fleetType: FleetType
    
    @objc var fleetTypeObjc: FleetTypeObjc {
        switch fleetType {
        case .pooling:
            return .pooling
        case .taxi:
            return .taxi
        }
    }
}
