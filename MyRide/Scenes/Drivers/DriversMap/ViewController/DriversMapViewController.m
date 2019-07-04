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
    [self zoomToCurrentLocation];
}

-(void)zoomToCurrentLocation{
    __weak typeof(self) weakSelf = self;
    [LocationHelper.shared getCurrentLocationWithCompletion:^(CLLocation *location) {
        __strong typeof(self) strongSelf = weakSelf;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000);
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
    [_mapView registerClass:[DriverAnnotationView class] forAnnotationViewWithReuseIdentifier:@"kDriverAnnotationView"];
}
    
- (void)showList {
    [_viewModel presentDriversList];
}

- (void)showErrorMessageWithError:(NSError*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"alert.error.title", @"Sorry")
                                                                   message: error.localizedDescription
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"OK"
                                                       style: UIAlertActionStyleDefault
                                                     handler: nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)refreshPins{
    // clear current annotations
    [_mapView removeAnnotations: _mapView.annotations];
    
    // add anotations for new map bounds
    NSArray<DriverAnnotationViewModel*> *anotationsViewModels = [_viewModel anotationsForMap];
    
    for (DriverAnnotationViewModel* vm in anotationsViewModels) {
        DriverAnnotation *anotation = [[DriverAnnotation alloc] initWithViewModel:vm];
        [_mapView addAnnotation:anotation];
    }
}

-(MapBounds*)mapBoundsForMap:(MKMapView *)mapView{

    CGPoint northEastPoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint southWestPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    
    // northEast coordinate
    CLLocationCoordinate2D neCoord = [mapView convertPoint:northEastPoint
                                      toCoordinateFromView:mapView];
    // southWeast coordinate
    CLLocationCoordinate2D swCoord = [mapView convertPoint:southWestPoint
                                      toCoordinateFromView:mapView];
    
    MapBounds *mapBounds = [[MapBounds alloc] initWithNorthEastCoordinate:neCoord
                                                      southWestCoortinate:swCoord];
    
    return mapBounds;
}

// request viewmodel to update drivers for mapbounds
-(void) refreshDriversForMapbounds:(MapBounds *)mapBounds{
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

// MARK: - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MapBounds *mapBounds = [self mapBoundsForMap: mapView];
    [self refreshDriversForMapbounds:mapBounds];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // setup DriverAnnotationView with its viewModel
    
    DriverAnnotationView *annotationView = (DriverAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"kDriverAnnotationView"];
    if (annotationView == nil) {
        annotationView = [[DriverAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"kDriverAnnotationView"];
    } else {
        annotationView.annotation = annotation;
    }
    
    DriverAnnotation *driverAnnotation = (DriverAnnotation*) annotation;
    [annotationView bindViewModel: driverAnnotation.viewModel];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    // show alert message when tap callout
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"alert.success.title", @"Success")
                                                                   message: NSLocalizedString(@"drivers_map.request_driver.error", @"Erro requesting driver")
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"OK"
                                                       style: UIAlertActionStyleDefault
                                                     handler: nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
