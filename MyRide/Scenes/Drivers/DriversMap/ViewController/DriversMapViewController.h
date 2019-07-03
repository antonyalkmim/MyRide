//
//  DriversMapViewController.h
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

#import "DriversMapViewModel.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DriversMapViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
    
- (instancetype)initWithViewModel:(DriversMapViewModel *)viewModel;
    
@end

NS_ASSUME_NONNULL_END
