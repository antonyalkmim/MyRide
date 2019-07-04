//
//  AppCoordinator.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var rootViewController: UIViewController?
    
    var window: UIWindow?
    
    // MARK: - Child Coordinators
    
    private var driversMapCoordinator: DriversMapCoordinator?
    
    init() {
        // setup app navigation style
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0xEBC10B)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.black

        // setup window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
    
    func start() {
        // Open app in Drivers Map
        driversMapCoordinator = DriversMapCoordinator()
        driversMapCoordinator?.start()
        
        window?.rootViewController = driversMapCoordinator?.rootViewController
    }
    
    func stop() {
        driversMapCoordinator = nil
        rootViewController = nil
    }

}
