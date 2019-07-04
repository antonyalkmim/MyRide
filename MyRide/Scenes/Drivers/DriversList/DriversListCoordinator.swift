//
//  DriversListCoordinator.swift
//  MyRide
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DriversListCoordinator: Coordinator {
    
    // Drivers List
    var driversListNavigation: UINavigationController?
    
    let mapBounds: MapBounds
    let userLocation: CLLocation
    
    init(viewController: UIViewController, mapBounds: MapBounds, userLocation: CLLocation) {
        self.mapBounds = mapBounds
        self.userLocation = userLocation
        super.init()
        self.rootViewController = viewController
    }
    
    override func start() {
        let driversViewModel = DriversListViewModel(mapBounds: mapBounds, userLocation: userLocation)
        driversViewModel.delegate = self
        let driversListViewController = DriversListViewController(viewModel: driversViewModel)
        
        let navigation = UINavigationController(rootViewController: driversListViewController)
        driversListNavigation = navigation
        rootViewController?.present(navigation, animated: true, completion: nil)
    }
    
}

// MARK: - DriversListCoordinator
extension DriversListCoordinator: DriversListViewModelDelegate {
    func navigateBack(_ viewModel: DriversListViewModel) {
        driversListNavigation?.dismiss(animated: true, completion: nil)
    }
}
