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
    
    // DriversMap
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.rootViewController = navigationController
    }
    
    override func start() {
        let driversMapViewModel = DriversMapViewModel()
        driversMapViewModel.delegate = self
        let driversMapViewController = DriversMapViewController(viewModel: driversMapViewModel)
        
        navigationController.setViewControllers([driversMapViewController], animated: false)
    }
    
    private func showDriversList(mapBounds: MapBounds, userLocation: CLLocation) {
        guard let rootViewController = rootViewController else { return }
        let driversListCoordinator = DriversListCoordinator(viewController: rootViewController,
                                                            mapBounds: mapBounds,
                                                            userLocation: userLocation)
        driversListCoordinator.start()
        store(coordinator: driversListCoordinator)
    }
    
}

// MARK: - DriversMapViewModelDelegate
extension DriversMapCoordinator: DriversMapViewModelDelegate {
    func shouldPresentList(_ viewModel: DriversMapViewModel!, with mapBounds: MapBounds!, andUserLocation userLocation: CLLocation!) {
        showDriversList(mapBounds: mapBounds, userLocation: userLocation)
    }
}
