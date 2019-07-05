//
//  NumberFormatter+utils.swift
//  MyRide
//
//  Created by Antony Alkmim on 04/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    class var coordinateFormatter: NumberFormatter {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 7
        return formater
    }
    
    class var killometersDistanceFormatter: NumberFormatter {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 1
        return formater
    }
    
}
