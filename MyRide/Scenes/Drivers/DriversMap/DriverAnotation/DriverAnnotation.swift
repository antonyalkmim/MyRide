//
//  DriverAnnotationView.swift
//  MyRide
//
//  Created by Antony Alkmim on 03/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

@objcMembers class DriverAnnotation: NSObject, MKAnnotation {
    
    var viewModel: DriverAnnotationViewModel
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(viewModel: DriverAnnotationViewModel) {
        self.viewModel = viewModel
        self.coordinate = viewModel.coordinate
        self.title = viewModel.title
        self.subtitle = viewModel.subtitle
    }
}
