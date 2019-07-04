//
//  DriverAnnotationView.swift
//  MyRide
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import MapKit

@objcMembers class DriverAnnotationView: MKAnnotationView {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // style annotation
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backgroundColor = UIColor.clear
        
        // setup annotation
        canShowCallout = true
        calloutOffset = CGPoint.zero
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        imageView.frame = bounds
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bindViewModel(_ viewModel: DriverAnnotationViewModel) {
        imageView.image = viewModel.pinImage
        leftCalloutAccessoryView = UIImageView(image: viewModel.pinImage)
    }
    
}
