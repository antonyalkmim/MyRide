//
//  GetDriversResponse.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

struct GetDriversResponse: Decodable {
    let drivers: [Driver]
    
    enum CodingKeys: String, CodingKey {
        case drivers = "poiList"
    }
}
