//
//  MapViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 08.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "Route.h"
#import "RoutePoint.h"
#import "RoutePointAnnotation.h"
#import "MenuViewController.h"
#import "DetailViewController.h"
#import "FixedNavigationViewController.h"
#import "TESTModelManager.h"

@interface MapViewController () <MGLMapViewDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *centerToUserButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mapViewSetup];
    [self GenerateTestModel];
    [self ExtractRoutes];
    
//    MGLPointAnnotation *testPoint = [[MGLPointAnnotation alloc] init];
//    testPoint.coordinate = CLLocationCoordinate2DMake(55.782389, 49.129910);
//    testPoint.title = @"Test point";
//    testPoint.subtitle = [NSString stringWithFormat:@"%f ; %f", testPoint.coordinate.latitude, testPoint.coordinate.longitude];
//    [_mapView addAnnotation:testPoint];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)menuPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navVC = [sb instantiateViewControllerWithIdentifier:@"navVC"];
    navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    
    MenuViewController *mvc = [navVC.viewControllers lastObject];
    mvc.routes = _routes;
    [self presentViewController:navVC animated:YES completion:nil];
}
- (IBAction)toUserPressed:(id)sender {
//    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:_mapView.camera.centerCoordinate.latitude
//                                                  longitude:_mapView.camera.centerCoordinate.longitude];
//    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude
//                                                  longitude:_mapView.userLocation.coordinate.longitude];
//    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
//    
//    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:_mapView.userLocation.coordinate
//                                                            fromDistance:_mapView.camera.altitude
//                                                                   pitch:0
//                                                                 heading:0];
//    if (distance < 10000)
//        [_mapView flyToCamera:camera completionHandler:nil];
//    else
//        [_mapView setCamera:camera animated:NO];
    [_mapView setUserTrackingMode:MGLUserTrackingModeFollowWithCourse animated:YES];
}
- (IBAction)plusPressed:(id)sender {
    [_mapView setZoomLevel:_mapView.zoomLevel+0.5 animated:YES];
}
- (IBAction)minusPressed:(id)sender {
    [_mapView setZoomLevel:_mapView.zoomLevel-0.5 animated:YES];
}


- (void)mapViewSetup {
    [self preferredStatusBarStyle];

    _mapView.showsUserLocation = YES;
    
    _mapView.latitude = 55.783108;
    _mapView.longitude = 49.119894;
    _mapView.zoomLevel = 10.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
    
    [_mapView.attributionButton setAlpha:0.0];
    [_mapView.logoView setAlpha:0.5];
    
    [_mapView setUserTrackingMode:MGLUserTrackingModeFollowWithHeading animated:YES];
    
    //    NSLog(@"AFTER WORK:\nMAP VIEW USER LOCATION: %@", _mapView.showsUserLocation? @"ON" : @"OFF");
}
- (void)GenerateTestModel {
    if (!_routes) {
        _routes = [NSArray arrayWithObject:[TESTModelManager getRoute]];
    }
}
- (void)ExtractRoutes {
    NSMutableArray *annotations = [NSMutableArray new];
    for (Route *curRoute in _routes) {
        RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[curRoute firstPoint]];
        [annotations addObject:pointAnnotation];
        
//        NSLog(@"CURRENT ROUTE: %@", curRoute.name);
//        NSLog(@"POINT ANNOTATION PARENT: %@", pointAnnotation.routePoint.route.name);
    }
    [_mapView addAnnotations:annotations];
}

#pragma mark - MGLMapView delegate methods

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

-(MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    // This example is only concerned with point annotations.
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];
    
    // For better performance, always try to reuse existing annotations.
    CustomAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    // If there’s no reusable annotation view available, initialize a new one.
    if (!annotationView) {
        annotationView = [[CustomAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
        annotationView.frame = CGRectMake(0, 0, 14, 14);
        
        // Set the annotation view’s background color to a value determined by its longitude.
        CGFloat hue = [annotation isKindOfClass:[RoutePointAnnotation class]] ? (242/360.0) : 0.75;
        annotationView.backgroundColor = [UIColor colorWithHue:hue saturation:0.5 brightness:1 alpha:1];
    }
    
    return annotationView;
}

-(UIView<MGLCalloutView> *)mapView:(MGLMapView *)mapView calloutViewForAnnotation:(id<MGLAnnotation>)annotation {
// Если у annotation нет title'a то вообще не работает!!!
//    //Only show callouts for `Hello world!` annotation
//    if ([annotation respondsToSelector:@selector(title)])
    NSLog(@"Called annotation: %@", annotation);
    if ([annotation isKindOfClass:[RoutePointAnnotation class]])
    {
        // Instantiate and return our custom callout view
        CustomCalloutView *calloutView = [[CustomCalloutView alloc] initWithAnnotation:annotation];
        calloutView.representedObject = annotation;
        return calloutView;
    }
    return nil;
}


-(void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation {
    if ([annotation isKindOfClass:[RoutePointAnnotation class]]) {
        RoutePointAnnotation *ann = annotation;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *dvc = [sb instantiateViewControllerWithIdentifier:@"detailVC"];
        [dvc configureWithRoute:ann.routePoint.route];
        
        UINavigationController *navVC = [[FixedNavigationViewController alloc] initWithRootViewController:dvc];
        navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:navVC animated:YES completion:nil];
        
        NSLog(@"Route opened: %@", ann.routePoint.route.title);
    }
    [mapView deselectAnnotation:annotation animated:YES];
}

-(void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
