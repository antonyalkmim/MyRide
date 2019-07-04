//
//  DriverCellViewModelTests.swift
//  MyRideTests
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import XCTest
import CoreLocation

@testable import MyRide

class DriverCellViewModelTests: XCTestCase {
    
    func testRefreshDrivers() {
        // user in hamburg
        let fakeUserLocation = CLLocation(latitude: 53.56658, longitude: 10.039179)
        
        let vm = DriverCellViewModel(driver: driverMock, userLocation: fakeUserLocation)
        
        XCTAssertEqual(vm, vm)
        XCTAssertEqual(vm.identifier, "#739330")
        XCTAssertEqual(vm.driverFleetType, "Taxi")
        XCTAssertEqual(vm.latitudeFormatted, "53,6688066")
        XCTAssertEqual(vm.longitudeFormatted, "10,0199089")
        XCTAssertEqual(vm.distanceFormatted, "11,4 km")
        XCTAssertEqual(vm.driverIcon, Asset.taxiMap.image)
        
    }
    
    var driverMock: Driver {
        let jsonData = """
          {
           "id": 739330,
           "coordinate": {
            "latitude": 53.668806556867445,
            "longitude": 10.019908942943804
           },
           "fleetType": "TAXI",
           "heading": 245.2005654202569
          }
        """.data(using: String.Encoding.utf8)!
        
        return try! JSONDecoder().decode(Driver.self, from: jsonData)
    }
    
}
