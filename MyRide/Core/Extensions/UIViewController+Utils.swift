//
//  UIViewController+Utils.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // return bottom inset for iphone with rounded borders (iPhoneX, XS, XR, etc)
    var bottomInset: CGFloat {
        guard #available(iOS 11.0, *) else { return 0 }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    }
}
