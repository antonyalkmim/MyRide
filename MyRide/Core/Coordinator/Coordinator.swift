//
//  Coordinator.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorDelegate: class {
    func didFinish(coordinator: Coordinator)
}

class Coordinator {
    
    var childCoordinators = [UUID: Coordinator]()
    var rootViewController: UIViewController?
    var isAnimated: Bool = true
    
    let identifier = UUID()
    
    func start() {
        fatalError("this method should be overrided")
    }
    
    func store(coordinator: Coordinator) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators[coordinator.identifier]?.rootViewController?.dismiss(animated: false, completion: nil)
        childCoordinators[coordinator.identifier] = nil
    }
    
    deinit {
        childCoordinators.forEach { _, value in
            free(coordinator: value)
        }
    }
    
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs.identifier == lhs.identifier
    }
}
