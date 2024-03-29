//
//  DriversService.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

@objcMembers class DriversService: NSObject {
    
    let apiService: HttpService<DriversAPI> = HttpService<DriversAPI>()
    
    func getDrivers(mapBounds: MapBounds, completion: (([Driver]?, Error?) -> Void)?) {
        
        let request = DriversAPI.getDrivers(northEastCoordinate: Coordinate(coordinate: mapBounds.northEastCoordinate),
                                            southWestCoordinate: Coordinate(coordinate: mapBounds.southWestCoortinate))

        apiService.request(request) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    completion?(nil, err)
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(GetDriversResponse.self, from: data)
                        completion?(response.drivers, nil)
                    } catch {
                        completion?(nil, error)
                    }
                }
            }
        }
    }
    
}
