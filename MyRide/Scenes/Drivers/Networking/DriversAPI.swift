//
//  MyRideAPI.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

enum DriversAPI {
    case getDrivers(neCoordinate: Coordinate, swCoordinate: Coordinate)
}

extension DriversAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://fake-poi-api.mytaxi.com")!
    }
    
    var path: String {
        switch self {
        case let .getDrivers(p1, p2):
            return "/?p2Lat=\(p2.latitude)&p1Lon=\(p1.longitude)&p1Lat=\(p1.latitude)&p2Lon=\(p2.longitude)"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .getDrivers:
            return .get
        }
    }
    
    var task: TargetTypeTask {
        return .request
    }
    
    var body: Data? {
        return nil
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
