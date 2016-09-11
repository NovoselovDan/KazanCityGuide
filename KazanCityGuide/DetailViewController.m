//
//  DetailViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "DetailViewController.h"
#import "RoutePointAnnotation.h"
#import "CustomCalloutView.h"
#import "CustomAnnotationView.h"
@import Mapbox;

@interface DetailViewController () <MGLMapViewDelegate>
@property (nonatomic, strong)Route *route;
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@end

@implementation DetailViewController {
    dispatch_once_t token;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mapViewSetup];
//    [self navigationItemSetup];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationItemSetup];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureWithRoute:(Route *)route {
    _route = route;
}


- (void)navigationItemSetup {
    self.navigationController.navigationBar.topItem.title = @"Назад";

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
    title.text = _route.title;
    title.textColor = [self tintColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@".SFUIText-Semibold" size:17.0];
    [self.navigationItem setTitleView:title];
}
- (UIColor *)tintColor {
    return [UIColor colorWithHue:240/360.0 saturation:0.02 brightness:96 alpha:1.0];
}
- (void)mapViewSetup {
    _mapView.showsUserLocation = YES;
    
    RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    _mapView.centerCoordinate = pointAnnotation.coordinate;
    _mapView.zoomLevel = 8.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
    //    _mapView.userInteractionEnabled = NO;
    
    [_mapView addAnnotation:pointAnnotation];
}
- (void)adjustCamera {
    RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:pointAnnotation.coordinate.latitude
                                                  longitude:pointAnnotation.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude
                                                  longitude:_mapView.userLocation.coordinate.longitude];
    CLLocationDistance distance = [loc2 distanceFromLocation:loc1];
    
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:_mapView.userLocation.coordinate
                                                            fromDistance:distance
                                                                   pitch:0
                                                                 heading:0];
    [_mapView setCamera:camera animated:YES];
    
    
    
}
- (void)drawPolyline {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^(void)
                   {
                       RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
                       CLLocationCoordinate2D coordinates[2];
                       coordinates[0] = CLLocationCoordinate2DMake(pointAnnotation.coordinate.latitude, pointAnnotation.coordinate.longitude);
                       coordinates[1] = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
                       
                       
                       // Create our polyline with the formatted coordinates array
                       MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:2];
                       // Optionally set the title of the polyline, which can be used for:
                       //  - Callout view
                       //  - Object identification
                       // In this case, set it to the name included in the GeoJSON
                       polyline.title = @"Путь до первой точки"; // "Crema to Council Crest"
                       
                       // Add the polyline to the map, back on the main thread
                       // Use weak reference to self to prevent retain cycle
                       __weak typeof(self) weakSelf = self;
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                                                         [weakSelf.mapView addAnnotation:polyline];
                                          [weakSelf.mapView showAnnotations:@[polyline] animated:YES];
                                      });
                       
                       
                   });
}

#pragma mark - MGLMapView delegate methods

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return NO;
}
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
    dispatch_once(&token, ^{
        [self adjustCamera];
        [self drawPolyline];
    });
}
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
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
- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    if ([annotation isKindOfClass:[MGLPolyline class]]) {
        return 0.5;
    }
    return 1;
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
