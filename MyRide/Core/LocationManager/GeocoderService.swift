//
//  GeocoderService.swift
//  MyRide
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import CoreLocation

class GeocoderService {
    
    private let geocoder = CLGeocoder()
    
    /// Use CLGeocoder to get city name from location
    func getCityName(location: CLLocation, completion: @escaping (String?) -> Void) {
        
        // use geocoder to get the city name
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            let cityName = placemarks?.first?.locality
            completion(cityName)
        }
    }
    
}
