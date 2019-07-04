//
//  DriversService+Rx.swift
//  MyRide
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: DriversService {
    
    func getDrivers(mapBounds: MapBounds) -> Single<[Driver]> {
        return Single<[Driver]>
            .create(subscribe: { [weak base] single in
                
                base?.getDrivers(mapBounds: mapBounds, completion: { (drivers, error) in
                    if let err = error {
                        single(SingleEvent.error(err))
                        return
                    }
                    single(SingleEvent.success(drivers ?? []))
                })
                
                return Disposables.create()
            })
    }
}
