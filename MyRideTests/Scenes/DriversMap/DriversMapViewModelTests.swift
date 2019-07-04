//
//  DriversMapViewModelTests.swift
//  MyRideTests
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import XCTest

@testable import MyRide

class DriversMapViewModelTests: XCTestCase {
    
    var viewModel: DriversMapViewModel!
    var driversServiceMock: DriversServiceMock!
    
    var delegateExpectation: XCTestExpectation!
    var delegateMock: DriversMapViewModelDelegateMock?
    
    override func setUp() {
        
        driversServiceMock = DriversServiceMock()
        delegateMock = DriversMapViewModelDelegateMock()
        
        let vm = DriversMapViewModel(driversService: driversServiceMock)
        vm?.delegate = delegateMock
        viewModel = vm
    }
    
    override func tearDown() {
        driversServiceMock = nil
        delegateMock = nil
        viewModel = nil
    }
    
    func testRefreshDriversWithMapBounds() {
        let driversExpectation = expectation(description: "load drivers")
        driversServiceMock.driversMock = driversMock
        
        let mapBounds = MapBounds(northEastCoordinate: CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589),
                                  southWestCoortinate: CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891))
        
        viewModel.refreshDrivers(with: mapBounds) { error in
            XCTAssertNil(error)
            driversExpectation.fulfill()
        }
        
        wait(for: [driversExpectation], timeout: 1)
        
        let anotations = viewModel.anotationsForMap()
        XCTAssertEqual(anotations?.count, 2)
    }
    
    func testRefreshDriversWithMapBoundsError() {
        let driversExpectation = expectation(description: "load drivers")
        driversServiceMock.errorMock = HttpError.connectionError
        
        let mapBounds = MapBounds(northEastCoordinate: CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589),
                                  southWestCoortinate: CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891))
        
        viewModel.refreshDrivers(with: mapBounds) { error in
            XCTAssertEqual(error?.localizedDescription, HttpError.connectionError.localizedDescription)
            driversExpectation.fulfill()
        }
        
        wait(for: [driversExpectation], timeout: 1)
    }
    
    func testPresentDriversList() {
        delegateExpectation = expectation(description: "call delegate present list")
        delegateMock?.delegateExpectation = delegateExpectation
        
        // user in hamburg
        let fakeUserLocation = CLLocation(latitude: 53.56658, longitude: 10.039179)
        
        viewModel.userLocation = fakeUserLocation
        viewModel.presentDriversList()
        
        wait(for: [delegateExpectation], timeout: 1)
    }
    
   
    // MARK: - Data Mock
    
    var driversMock: [Driver] {
        let jsonData = """
        [{
           "id": 439670,
           "coordinate": {
            "latitude": 53.46036882190762,
            "longitude": 9.909716434648558
           },
           "fleetType": "POOLING",
           "heading": 344.19529122029735
          },
          {
           "id": 739330,
           "coordinate": {
            "latitude": 53.668806556867445,
            "longitude": 10.019908942943804
           },
           "fleetType": "TAXI",
           "heading": 245.2005654202569
          }]
        """.data(using: String.Encoding.utf8)!
        
        return try! JSONDecoder().decode([Driver].self, from: jsonData)
    }
}

class DriversMapViewModelDelegateMock: DriversMapViewModelDelegate {
    
    var delegateExpectation: XCTestExpectation?
    
    func shouldPresentList(_ viewModel: DriversMapViewModel!, with mapBounds: MapBounds!, andUserLocation userLocation: CLLocation!) {
        delegateExpectation?.fulfill()
    }
}
