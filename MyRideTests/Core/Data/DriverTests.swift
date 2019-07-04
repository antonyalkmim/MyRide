//
//  DriverTests.swift
//  MyRideTests
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import XCTest

@testable import MyRide

class DriverTests: XCTestCase {

    func testJsonParsing() {
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
        
        let driver = try? JSONDecoder().decode(Driver.self, from: jsonData)
        
        XCTAssertEqual(driver?.coordinate.latitude, 53.668806556867445)
        XCTAssertEqual(driver?.coordinate.longitude, 10.019908942943804)
        XCTAssertEqual(driver?.id, 739330)
        XCTAssertEqual(driver?.fleetType, FleetType.taxi)
        XCTAssertEqual(driver?.heading, 245.2005654202569)
    }

}
