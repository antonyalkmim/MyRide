//
//  DriversListViewModel.swift
//  MyRideTests
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import XCTest
import RxSwift
import RxDataSources
import RxBlocking
import RxTest

@testable import MyRide

class DriversListViewModelTests: XCTestCase {
    
    var viewModel: DriversListViewModelType!
    var disposeBag: DisposeBag!
    var driversServiceMock: DriversServiceMock!
    
    var delegateExpectation: XCTestExpectation!
    var delegateMock: DriversListViewModelDelegateMock?
    
    override func setUp() {
        
        disposeBag = DisposeBag()
        
        delegateMock = DriversListViewModelDelegateMock()
        driversServiceMock = DriversServiceMock()
        
        // setup viewModel
        // hamburg area
        let mapBounds = MapBounds(northEastCoordinate: CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589),
                                  southWestCoortinate: CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891))
        
        // user in hamburg
        let fakeUserLocation = CLLocation(latitude: 53.56658, longitude: 10.039179)
        
        let vm = DriversListViewModel(mapBounds: mapBounds,
                                      userLocation: fakeUserLocation,
                                      driversService: driversServiceMock)
        vm.delegate = delegateMock
        viewModel = vm
        
    }
    
    override func tearDown() {
        driversServiceMock = nil
        viewModel = nil
        disposeBag = nil
    }
    
    func testRefreshDrivers() {
        driversServiceMock.driversMock = driversMock
        viewModel.inputs.refreshDrivers.onNext(())
        
        let cellsViewModels = (try? viewModel.outputs.itemsViewModel.toBlocking().first()?.first?.items) ?? []
        
        XCTAssertEqual(cellsViewModels.count, 2)
        // first item
        XCTAssertEqual(cellsViewModels.first?.driver.fleetType, FleetType.pooling)
        XCTAssertEqual(cellsViewModels.first?.driver.id, 439670)
        
        // second item
        XCTAssertEqual(cellsViewModels.last?.driver.fleetType, FleetType.taxi)
    }
    
    func testRefreshDriversError() {
        let scheduler = TestScheduler(initialClock: 0)
        let errorMessageObserver = scheduler.createObserver(String.self)
        
        viewModel.outputs.errorMessage
            .subscribe(errorMessageObserver)
            .disposed(by: disposeBag)
        
        driversServiceMock.errorMock = HttpError.noInternetConnection
        viewModel.inputs.refreshDrivers.onNext(())
        
        scheduler.start()
        
        // list should be empty
        let cellsViewModels = (try? viewModel.outputs.itemsViewModel.toBlocking().first()?.first?.items) ?? []
        XCTAssertEqual(cellsViewModels.count, 0)
        
        // error message
        let errorMessage = errorMessageObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(errorMessage, HttpError.noInternetConnection.localizedDescription)
    }
    
    func testRefreshDriversLoading() {
        let scheduler = TestScheduler(initialClock: 0)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.isLoading
            .subscribe(isLoadingObserver)
            .disposed(by: disposeBag)
        
        driversServiceMock.driversMock = driversMock
        viewModel.inputs.refreshDrivers.onNext(())
        
        scheduler.start()
        
        // isLoading states
        let states = isLoadingObserver.events.compactMap { $0.value.element }
        XCTAssertEqual(states, [false, true, false])
    }
    
    func testCloseList() {
        delegateExpectation = expectation(description: "call delegate close list")
        delegateMock?.delegateExpectation = delegateExpectation
        
        viewModel.inputs.closeList.onNext(())
        
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

class DriversListViewModelDelegateMock: DriversListViewModelDelegate {
    var delegateExpectation: XCTestExpectation?
    func navigateBack(_ viewModel: DriversListViewModel) {
        delegateExpectation?.fulfill()
    }
}
