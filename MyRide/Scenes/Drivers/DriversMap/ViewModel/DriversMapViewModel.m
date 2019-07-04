//
//  DriversMapViewModel.m
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

#import "DriversMapViewModel.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MyRide-Swift.h"

@interface DriversMapViewModel ()
@property (nonatomic, retain) NSArray<Driver*> *drivers;
@property (nonatomic, retain) MapBounds *currentMapBounds;
@property (nonatomic, retain) DriversService *driversService;
@end


@implementation DriversMapViewModel

@synthesize delegate;
@synthesize drivers;
@synthesize userLocation;
@synthesize driversService;

- (instancetype)init
{
    DriversService *driversService = [[DriversService alloc] init];
    return [self initWithDriversService:driversService];
}

- (instancetype)initWithDriversService:(DriversService *)driversService
{
    self = [super init];
    if (self) {
        self.driversService = driversService;
    }
    return self;
}

// MARK: - Inputs
- (void)presentDriversList {
    
    if (userLocation == nil) {
        return;
    }
    
    [delegate shouldPresentList:self
                  withMapBounds: _currentMapBounds
                andUserLocation: userLocation];
}

- (void)refreshDriversWithMapBounds:(MapBounds *)mapBounds withCompletion:(void (^)(NSError*))completion {
    
    _currentMapBounds = mapBounds;
    
    __weak typeof(self) weakSelf = self;
    [driversService getDriversWithMapBounds:mapBounds
                                 completion:^(NSArray<Driver*> *drivers, NSError *err) {
                                     __strong typeof(self) strongSelf = weakSelf;
                                     if (err != nil) {
                                         completion(err);
                                         return;
                                     }
                                     strongSelf.drivers = drivers;
                                     completion(nil);
                                 }];
}

// MARK: - Outputs

- (NSArray<DriverAnnotationViewModel *> *)anotationsForMap {
    NSMutableArray *anotationsArr = [[NSMutableArray alloc] init];

    // create anotation viewModel
    for (Driver* driver in drivers) {
        DriverAnnotationViewModel *vm = [[DriverAnnotationViewModel alloc] initWithDriver: driver
                                                                             userLocation: userLocation];
        [anotationsArr addObject:vm];
    }

    return anotationsArr;
}

@end
