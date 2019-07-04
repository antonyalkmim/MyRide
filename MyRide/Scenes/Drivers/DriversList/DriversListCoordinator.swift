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
    
    var rootViewController: UIViewController?
    
    var driversListNavigation: UINavigationController?
    
    private let mapBounds: MapBounds
    private let userLocation: CLLocation
    
    init(viewController: UIViewController, mapBounds: MapBounds, userLocation: CLLocation) {
        self.rootViewController = viewController
        self.mapBounds = mapBounds
        self.userLocation = userLocation
    }
    
    func start() {
        let driversViewModel = DriversListViewModel(mapBounds: mapBounds, userLocation: userLocation)
        driversViewModel.delegate = self
        let driversListViewController = DriversListViewController(viewModel: driversViewModel)
        
        let navigation = UINavigationController(rootViewController: driversListViewController)
        driversListNavigation = navigation
        rootViewController?.present(navigation, animated: true, completion: nil)
    }
    
    func stop() {
        driversListNavigation = nil
        rootViewController = nil
    }
    
}

// MARK: - DriversListCoordinator
extension DriversListCoordinator: DriversListViewModelDelegate {
    func navigateBack(_ viewModel: DriversListViewModel) {
        driversListNavigation?.dismiss(animated: true, completion: nil)
    }
}
