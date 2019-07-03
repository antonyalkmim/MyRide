//
//  DriversCoordinator.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DriversCoordinator: Coordinator {
    
    // DriversMap
    var navigationController: UINavigationController
    
    // Drivers List
    var driversListNavigation: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let driversViewModel = DriversMapViewModel()
        driversViewModel.delegate = self
        let driversMapViewController = DriversMapViewController(viewModel: driversViewModel)
        
        navigationController.setViewControllers([driversMapViewController], animated: false)
        rootViewController = navigationController
    }
    
    private func showDriversList(mapBounds: MapBounds, userLocation: CLLocation) {
        
        let driversViewModel = DriversListViewModel(mapBounds: mapBounds, userLocation: userLocation)
        driversViewModel.delegate = self
        let driversListViewController = DriversListViewController(viewModel: driversViewModel)
        
        let navigation = UINavigationController(rootViewController: driversListViewController)
        driversListNavigation = navigation
        rootViewController?.present(navigation, animated: true, completion: nil)
    }
    
}

extension DriversCoordinator: DriversMapViewModelDelegate {
    func shouldPresentList(_ viewModel: DriversMapViewModel!, with mapBounds: MapBounds!, andUserLocation userLocation: CLLocation!) {
        showDriversList(mapBounds: mapBounds, userLocation: userLocation)
    }
}

extension DriversCoordinator: DriversListViewModelDelegate {
    func navigateBack(_ viewModel: DriversListViewModel) {
        driversListNavigation?.dismiss(animated: true, completion: nil)
    }
}
