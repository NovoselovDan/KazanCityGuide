//
//  MapViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 08.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnnotationView.h"

@interface MapViewController () <MGLMapViewDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mapViewSetup];
    
    MGLPointAnnotation *testPoint = [[MGLPointAnnotation alloc] init];
    testPoint.coordinate = CLLocationCoordinate2DMake(55.787389, 49.121610);
    testPoint.title = @"Test point";
    
    [_mapView addAnnotation:testPoint];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapViewSetup {
    _mapView.showsUserLocation = YES;
    
    _mapView.latitude = 55.783108;
    _mapView.longitude = 49.119894;
    _mapView.zoomLevel = 10.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
    
    NSLog(@"AFTER WORK:\nMAP VIEW USER LOCATION: %@", _mapView.showsUserLocation? @"ON" : @"OFF");
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
//        CGFloat hue = (CGFloat)annotation.coordinate.longitude / 100;
        CGFloat hue = (242/360.0);
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
