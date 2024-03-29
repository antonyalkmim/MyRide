//
//  DriversListViewModel.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxRelay
import CoreLocation
import RxCocoa

typealias DriverSectionViewModel = AnimatableSectionModel<String, DriverCellViewModel>

protocol DriversListViewModelDelegate: AnyObject {
    func navigateBack(_ viewModel: DriversListViewModel)
}

protocol DriversListViewModelInputs {
    var closeList: PublishSubject<Void> { get }
    var refreshDrivers: PublishSubject<Void> { get }
}

protocol DriversListViewModelOutputs {
    var cityName: BehaviorSubject<String> { get }
    var isLoading: ActivityIndicator { get }
    var errorMessage: PublishSubject<String> { get }
    var itemsViewModel: Observable<[DriverSectionViewModel]> { get }
}

protocol DriversListViewModelType {
    var inputs: DriversListViewModelInputs { get }
    var outputs: DriversListViewModelOutputs { get }
}

class DriversListViewModel: DriversListViewModelType, DriversListViewModelInputs, DriversListViewModelOutputs {
    
    var inputs: DriversListViewModelInputs { return self }
    var outputs: DriversListViewModelOutputs { return self }
    
    weak var delegate: DriversListViewModelDelegate?
    
    // MARK: - Dependencies
    
    let driversService: DriversService
    let geocoderService: GeocoderService
    
    // MARK: - Rx Inputs
    
    var closeList       = PublishSubject<Void>()
    var refreshDrivers  = PublishSubject<Void>()
    
    // MARK: - Rx Outputs
    
    var cityName        = BehaviorSubject<String>(value: "-")
    var errorMessage    = PublishSubject<String>()
    var isLoading       = ActivityIndicator()
    var itemsViewModel: Observable<[DriverSectionViewModel]> {
        return drivers
            .asObservable()
            .map { [weak self] drivers in
                guard let strongSelf = self else { fatalError("self should not be nil") }
                let vms = drivers.map { DriverCellViewModel(driver: $0, userLocation: strongSelf.userLocation) }
                let section = DriverSectionViewModel(model: "", items: vms)
                return [section]
        }
    }
    
    // MARK: - Private
    
    private let drivers = BehaviorRelay<[Driver]>(value: [])
    
    private let userLocation: CLLocation
    private let mapBounds: MapBounds
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init(mapBounds: MapBounds,
         userLocation: CLLocation,
         driversService: DriversService = DriversService(),
         geocoderService: GeocoderService = GeocoderService()) {
        
        self.mapBounds = mapBounds
        self.userLocation = userLocation
        self.driversService = driversService
        self.geocoderService = geocoderService
        
        closeList.bind { [weak self] in
            guard let strongSelf = self else { return }
            self?.delegate?.navigateBack(strongSelf)
        }.disposed(by: disposeBag)
        
        refreshDrivers.bind { [weak self] in
            self?.loadDrivers()
        }.disposed(by: disposeBag)
        
        // load city name from current mapbounds
        loadCityName()
    }
    
    // MARK: - Private methods
    
    private func loadCityName() {
        
        let cityCoordinate = mapBounds.centerCoordinate
        let cityLocation = CLLocation(latitude: cityCoordinate.latitude,
                                      longitude: cityCoordinate.longitude)
        
        // use geocoder to get the city name
        geocoderService.getCityName(location: cityLocation) { [weak self] cityName in
            let cityName = cityName ?? "-"
            self?.cityName.onNext(cityName)
        }
    }
    
    private func loadDrivers() {
        driversService.rx.getDrivers(mapBounds: mapBounds)
            .trackActivity(isLoading)
            .subscribe { [weak self] event in
                switch event {
                case .next(let drivers):
                    self?.drivers.accept(drivers)
                case .error(let err):
                    self?.errorMessage.onNext(err.localizedDescription)
                default: break
                }
            }.disposed(by: disposeBag)
    }
    
}
