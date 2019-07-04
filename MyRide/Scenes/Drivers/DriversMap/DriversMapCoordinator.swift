//
//  DriversMapCoordinator.swift
//  MyRide
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DriversMapCoordinator: Coordinator {
    
    var rootViewController: UIViewController?
    
    private let navigationController: UINavigationController
    
    // MARK: - ChildCoordinators
    
    private var driversListCoordinator: DriversListCoordinator?
    
    // MARK: - Initializer
    
    init() {
        self.navigationController = UINavigationController()
        self.rootViewController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        let driversMapViewModel = DriversMapViewModel()
        driversMapViewModel.delegate = self
        let driversMapViewController = DriversMapViewController(viewModel: driversMapViewModel)
        
        navigationController.setViewControllers([driversMapViewController], animated: false)
    }
    
    func stop() {
        driversListCoordinator = nil
    }
    
    // MARK: - Private flows
    
    private func showDriversList(mapBounds: MapBounds, userLocation: CLLocation) {
        guard let rootViewController = rootViewController else { return }
        driversListCoordinator = DriversListCoordinator(viewController: rootViewController,
                                                            mapBounds: mapBounds,
                                                            userLocation: userLocation)
        driversListCoordinator?.start()
    }
    
}

// MARK: - DriversMapViewModelDelegate

extension DriversMapCoordinator: DriversMapViewModelDelegate {
    func shouldPresentList(_ viewModel: DriversMapViewModel!, with mapBounds: MapBounds!, andUserLocation userLocation: CLLocation!) {
        showDriversList(mapBounds: mapBounds, userLocation: userLocation)
    }
}
