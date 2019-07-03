//
//  FleetType.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

enum FleetType: String, Decodable {
    case pooling = "POOLING"
    case taxi = "TAXI"
}

@objc enum FleetTypeObjc: Int, RawRepresentable {
    case pooling = 0
    case taxi = 1
    
    typealias RawValue = String
    
    var rawValue: String {
        switch self {
        case .pooling:
            return "Pooling"
        case .taxi:
            return "Taxi"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "POOLING":
            self = .pooling
        case "TAXI":
            self = .taxi
        default:
            self = .taxi
        }
    }
}
