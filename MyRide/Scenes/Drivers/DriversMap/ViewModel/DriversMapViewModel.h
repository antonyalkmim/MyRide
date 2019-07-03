//
//  DriversMapViewModel.h
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class MapBounds;
@class DriversMapViewModel;

@protocol DriversMapViewModelDelegate
@optional
- (void)shouldPresentList:(DriversMapViewModel *)viewModel
            withMapBounds:(MapBounds *)mapBounds
          andUserLocation:(CLLocation *)userLocation;
@end

@interface DriversMapViewModel : NSObject
@property (nonatomic, weak) id <DriversMapViewModelDelegate> delegate;
@property (nonatomic, strong) CLLocation *userLocation;

// inputs
- (void)presentDriversList;
- (void)refreshDriversWithMapBounds:(MapBounds *)mapBounds
                     withCompletion:(void (^)(NSError*))completion;

// outputs
- (NSArray<id<MKAnnotation>> *)anotationsForMap;

@end
