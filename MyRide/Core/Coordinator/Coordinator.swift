//
//  Coordinator.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var rootViewController: UIViewController? { get }
    func start()
    func stop()
}
