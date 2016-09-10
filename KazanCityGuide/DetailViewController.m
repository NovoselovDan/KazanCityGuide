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

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mapViewSetup];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configureWithRoute:(Route *)route {
    _route = route;
}

- (void)mapViewSetup {
    _mapView.showsUserLocation = YES;
    
    RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    _mapView.centerCoordinate = pointAnnotation.coordinate;
    _mapView.zoomLevel = 8.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
//    _mapView.userInteractionEnabled = NO;
    
    [_mapView addAnnotation:pointAnnotation];
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:pointAnnotation.coordinate.latitude
                                                  longitude:pointAnnotation.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude
                                                  longitude:_mapView.userLocation.coordinate.longitude];
    NSLog(@"my location: \t%@", [loc2 description]);
    NSLog(@"point location: \t%@", [loc1 description]);

    CLLocationDistance distance = [loc2 distanceFromLocation:loc1];
    NSLog(@"Distance: %f", distance);
    
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:_mapView.userLocation.coordinate
                                                            fromDistance:distance*10
                                                                   pitch:0
                                                                 heading:0];
//    [_mapView flyToCamera:camera withDuration:10.0 completionHandler:^{
//        
//    }];
}
-(void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
    [self drawPolyline];
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
                           });
            
            
        });
}

- (void)navigationItemSetup {
    
}


#pragma mark - MGLMapView delegate methods

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return NO;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
