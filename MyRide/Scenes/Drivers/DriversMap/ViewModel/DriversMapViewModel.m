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
@end


@implementation DriversMapViewModel

@synthesize delegate;
@synthesize drivers;
@synthesize userLocation;

DriversService *driversService;

- (instancetype)init
{
    self = [super init];
    if (self) {
        driversService = [[DriversService alloc] init];
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

- (NSArray<id<MKAnnotation>> *)anotationsForMap {
    NSMutableArray *anotationsArr = [[NSMutableArray alloc] init];
    
    for (Driver* driver in drivers) {
        // create anotation
        MKPointAnnotation *anotation = [[MKPointAnnotation alloc] init];
        anotation.coordinate = CLLocationCoordinate2DMake(driver.coordinate.latitude, driver.coordinate.longitude);
        
        // Title - fleetType
        switch (driver.fleetTypeObjc) {
            case FleetTypeObjcTaxi:
                anotation.title = @"Taxi";
                break;
            case FleetTypeObjcPooling:
                anotation.title = @"Pooling";
                break;
        }
        
        // Subtitle - driver distance from user
        CLLocation *driverLocation = [[CLLocation alloc] initWithLatitude:driver.coordinate.latitude
                                                                longitude:driver.coordinate.longitude];
        CLLocationDistance distance = [userLocation distanceFromLocation:driverLocation] / 1000;
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = [NSLocale currentLocale];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.usesGroupingSeparator = YES;
        numberFormatter.groupingSeparator = @",";
        numberFormatter.maximumFractionDigits = 1;
        
        NSString *distanceFormatted = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:distance]];
        anotation.subtitle = [NSString stringWithFormat:@"%@ km", distanceFormatted];
        
        [anotationsArr addObject:anotation];
    }
    
    return anotationsArr;
}

@end
