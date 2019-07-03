//
//  DriversMapViewController.m
//  MyRide
//
//  Created by Antony Alkmim on 02/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

#import "DriversMapViewController.h"
#import "DriversMapViewModel.h"
#import <MapKit/MapKit.h>
#import "MyRide-Swift.h"

@interface DriversMapViewController ()
    
@property (nonatomic, strong, readonly) DriversMapViewModel *viewModel;
    
@end

@implementation DriversMapViewController

- (instancetype)initWithViewModel:(DriversMapViewModel *)viewModel {
    self = [super initWithNibName:@"DriversMapViewController" bundle: NULL];
    if (!self) return NULL;
    
    _viewModel = viewModel;
    
    return self;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    __weak typeof(self) weakSelf = self;
    [LocationHelper.shared getCurrentLocationWithCompletion:^(CLLocation *location) {
        __strong typeof(self) strongSelf = weakSelf;
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
        [strongSelf.mapView setRegion:region animated:YES];
        
        strongSelf.viewModel.userLocation = location;
    }];
    
}

- (void)setupViews {
    self.title = NSLocalizedString(@"drivers_map.title", @"Map Title");
    
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"ic_list"]
                                                                 style: UIBarButtonItemStylePlain
                                                                target: self
                                                                action: @selector(showList)];
    self.navigationItem.rightBarButtonItem = listItem;
    
    // mapview
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
}
    
- (void)showList {
    [_viewModel presentDriversList];
}

- (void)showErrorMessageWithError:(NSError*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"alert.error.title", @"Sorry")
                                                                   message: error.localizedFailureReason
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"OK"
                                                       style: UIAlertActionStyleDefault
                                                     handler: nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)refreshPins{
    [_mapView removeAnnotations: _mapView.annotations];
    NSArray<MKPointAnnotation*> *anotations = [_viewModel anotationsForMap];
    [_mapView addAnnotations: anotations];
}


// MARK: - MKMapViewDelegate


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CGPoint nePoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    
    CLLocationCoordinate2D neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    MapBounds *mapBounds = [[MapBounds alloc] initWithP1:neCoord p2:swCoord];
    
    __weak typeof(self) weakSelf = self;
    [_viewModel refreshDriversWithMapBounds:mapBounds withCompletion:^(NSError * err) {
        __strong typeof(self) strongSelf = weakSelf;
        if (err != nil) {
            [strongSelf showErrorMessageWithError:err];
            return;
        }
        [strongSelf refreshPins];
    }];
}


@end
