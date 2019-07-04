//
//  MyRideAPI.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

public enum DriversAPI {
    case getDrivers(northEastCoordinate: Coordinate, southWestCoordinate: Coordinate)
}

extension DriversAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://fake-poi-api.mytaxi.com")!
    }
    
    var path: String {
        switch self {
        case let .getDrivers(northEastCoordinate, southWestCoordinate):
            return String(format: "/?p2Lat=%f&p1Lon=%f&p1Lat=%f&p2Lon=%f",
                southWestCoordinate.latitude,
                northEastCoordinate.longitude,
                northEastCoordinate.latitude,
                southWestCoordinate.longitude)
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .getDrivers:
            return .get
        }
    }
    
    // Request JSON Body
    var body: Data? {
        return nil
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    // Mock reponse Data
    var sampleData: Data {
        return Data()
    }
    
}
