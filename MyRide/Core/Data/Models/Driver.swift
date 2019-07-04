//
//  Driver.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

@objcMembers public class Driver: NSObject, Decodable {
    let id: UInt
    let heading: Double
    let coordinate: Coordinate
    let fleetType: FleetType
}
