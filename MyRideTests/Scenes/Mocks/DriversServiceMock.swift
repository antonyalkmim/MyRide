//
//  DriversServiceMock.swift
//  MyRideTests
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

@testable import MyRide

class DriversServiceMock: DriversService {
    
    // results
    var driversMock: [Driver]?
    var errorMock: Error?
    
    // MARK: - DriversService
    
    override func getDrivers(mapBounds: MapBounds, completion: (([Driver]?, Error?) -> Void)?) {
        completion?(driversMock, errorMock)
    }
}
