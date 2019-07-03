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
    
    private var navigationController: UINavigationController?
    
    override init() {
        super.init()
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0xEBC10B)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.black
        
        self.navigationController = UINavigationController()
        self.rootViewController = navigationController
        
    }
    
    override func start() {
        // TODO: add logic to check if user is already logged in
        enterApp()
    }
    
    private func enterApp() {
        guard let navigation = navigationController else { return }
        let coordinator = DriversCoordinator(navigationController: navigation)
        coordinator.start()
        store(coordinator: coordinator)
    }

}
