//
//  ServiceResponseResult.swift
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

public enum ServiceResponseResult<T> {
    case failure(Error)
    case success(T)
}
