//
//  DriverAnnotationTests.swift
//  MyRideTests
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import XCTest

@testable import MyRide

class DriverAnnotationTests: XCTestCase {
    
    func testInitAnnotation() {
        
        let fakeUserLocation = CLLocation(latitude: 53.56658, longitude: 10.039179)
        let vm = DriverAnnotationViewModel(driver: driverMock, userLocation: fakeUserLocation)
        
        let annotation = DriverAnnotation(viewModel: vm)
        
        XCTAssertEqual(annotation.coordinate.latitude, driverMock.coordinate.latitude)
        XCTAssertEqual(annotation.coordinate.longitude, driverMock.coordinate.longitude)
        XCTAssertEqual(annotation.title, "Taxi")
        XCTAssertEqual(annotation.subtitle, "11,4 km")
    }
    
    // MARK: - Mocks
    
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

