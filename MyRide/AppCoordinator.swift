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
    
    var window: UIWindow!
    
    override init() {
        super.init()
        
        // setup app navigation style
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0xEBC10B)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.black
        
        // setup rootViewController
        self.navigationController = UINavigationController()
        self.rootViewController = navigationController
        
        // setup window
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
    override func start() {
        // TODO: add logic to check if user is already logged in
        enterApp()
    }
    
    private func enterApp() {
        guard let navigation = navigationController else { return }
        let coordinator = DriversMapCoordinator(navigationController: navigation)
        coordinator.start()
        store(coordinator: coordinator)
    }

}
