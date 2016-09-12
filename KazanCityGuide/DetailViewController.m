//
//  DetailViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "DetailViewController.h"
#import "PointViewController.h"
#import "FixedNavigationViewController.h"
#import "RoutePointAnnotation.h"
#import "CustomCalloutView.h"
#import "CustomAnnotationView.h"
#import "RouteInfoTableViewCell.h"
#import "FeedbackTableViewCell.h"
@import Mapbox;

#define ToRadian(x) ((x) * M_PI/180)
#define ToDegrees(x) ((x) * 180/M_PI)

@interface DetailViewController () <MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)Route *route;
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

//Map Components
@property (weak, nonatomic) IBOutlet UIView *mapComponentsView;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;


@end


@implementation DetailViewController {
    dispatch_once_t token;
    CGRect tableViewInitialFrame, okButtonInitialFrame, subtitbleInitialFrame;
    NSArray *mapComponents, *detailComponents;
    RoutePointAnnotation *routePointAnnotation;
    MGLPolyline *currentPolyline;
}
- (void)configureWithRoute:(Route *)route {
    _route = route;
    routePointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    token = 0;
    
    _subtitleLabel.font = _mapSubtitleLabel.font = [UIFont fontWithName:@".SFUIText-Semibold" size:10.0];
    _subtitleLabel.textColor = _mapSubtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    _taskLabel.font = [UIFont fontWithName:@".SFUIText-Medium" size:17.0];
    _taskLabel.textColor = [self tintColor];
    _taskLabel.shadowColor = [UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0];
    _taskLabel.text = @"Следуйте к следующему месту";
    
    mapComponents = @[_exitButton, _taskLabel, _mapSubtitleLabel, _centerButton, _plusButton, _minusButton];
    detailComponents = @[_okButton, _subtitleLabel, _tableView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationItemSetup];
    [self mapViewSetup];
    [self tableViewSetup];
    
    if (!_mapView.hidden) {
        for (UIView *view in mapComponents) {
            [view setHidden:YES];
            [view setAlpha:0.0];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okPressed:(id)sender {
    _mapView.userInteractionEnabled = YES;
    [self.navigationController setNavigationBarHidden:!(self.navigationController.navigationBar.hidden) animated:YES];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (UIView *view in detailComponents) {
                             [view setAlpha:0.0];
                         }
                         for (UIView *view in mapComponents) {
                             [view setHidden:NO];
                             [view setAlpha:1.0];
                         }
                     } completion:^(BOOL finished) {
                         for (UIView *view in detailComponents) {
                             [view setHidden:YES];
                         }
                         [self adjustCamera];
                     }];
}
- (IBAction)exitPressed:(id)sender {
    _mapView.userInteractionEnabled = NO;
    [self.navigationController setNavigationBarHidden:!(self.navigationController.navigationBar.hidden) animated:YES];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (UIView *view in mapComponents) {
                             [view setAlpha:0.0];
                         }
                         for (UIView *view in detailComponents) {
                             [view setHidden:NO];
                             [view setAlpha:1.0];
                         }
                     } completion:^(BOOL finished) {
                         for (UIView *view in mapComponents) {
                             [view setHidden:YES];
                         }
                         [self adjustCamera];
                     }];
}
- (IBAction)centerPressed:(id)sender {
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
    [_mapView setUserTrackingMode:MGLUserTrackingModeFollowWithHeading animated:YES];
}
- (IBAction)plusPresse:(id)sender {
    [_mapView setZoomLevel:_mapView.zoomLevel+0.5 animated:YES];
}
- (IBAction)minusPressed:(id)sender {
    [_mapView setZoomLevel:_mapView.zoomLevel-0.5 animated:YES];
    [self pushPointViewControllerWithAnnotation:routePointAnnotation];
}

- (void)navigationItemSetup {
    if ([self.navigationController.viewControllers[0] isKindOfClass:[self class]]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 75, 20);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 17, 17)];
        [imgView setImage:[UIImage imageNamed:@"Map"]];
        [btn addSubview:imgView];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 55, 20)];
        lab.text = @"Карта";
        lab.textColor = [self tintColor];
        [btn addSubview:lab];
        [btn addTarget:self action:@selector(mapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barBtn;
        self.navigationItem.leftBarButtonItem.tintColor = [self tintColor];
    } else {
        self.navigationController.navigationBar.topItem.title = @"Назад";
    }

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
    title.text = _route.title;
    title.textColor = [self tintColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@".SFUIText-Semibold" size:17.0];
    [self.navigationItem setTitleView:title];
}
- (IBAction)mapButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (UIColor *)tintColor {
    return [UIColor colorWithHue:240/360.0 saturation:0.02 brightness:96 alpha:1.0];
}

- (void)mapViewSetup {
    _mapView.showsUserLocation = YES;
    _mapView.userInteractionEnabled = NO;
    _mapView.zoomLevel = 8.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
    [_mapView.attributionButton setAlpha:0.0];
    [_mapView.logoView setAlpha:0.5];

    RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    _mapView.centerCoordinate = pointAnnotation.coordinate;
    [_mapView addAnnotation:pointAnnotation];
}
- (void)adjustCamera {
    [_mapView resetNorth];
    CLLocationDistance distance = [self distanceFromCoordinate:routePointAnnotation.coordinate];
    NSLog(@"mapview insets: %@", NSStringFromUIEdgeInsets(_mapView.contentInset));
    if (_taskLabel.hidden) {
//        [_mapView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0,
//                                                   [UIScreen mainScreen].bounds.size.height - _okButton.frame.origin.y, 0) animated:YES];
        [_mapView setContentInset:UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height - 300, 0) animated:NO];
        distance *= 6;
    } else {
        [_mapView setContentInset:UIEdgeInsetsMake(20, 0, 0, 4) animated:YES];
        distance *= 4;
    }
    NSLog(@"mapview insets edited: %@", NSStringFromUIEdgeInsets(_mapView.contentInset));

    
//    NSLog(@"adjusting distance: %f", distance);
//    NSLog(@"user's location: %@", _mapView.userLocation);
    CLLocationCoordinate2D midpoint = [[self class] midpointBetweenCoordinate:routePointAnnotation.coordinate
                                                                andCoordinate:_mapView.userLocation.coordinate];
    
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:midpoint
                                                            fromDistance:distance
                                                                   pitch:0
                                                                 heading:0];
    [_mapView setCamera:camera animated:YES];
    
    
    
}
- (void)drawPolyline {
    {
        //    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //    dispatch_async(backgroundQueue, ^(void)
        //                   {
        //                       CLLocationCoordinate2D coordinates[2];
        //                       coordinates[0] = CLLocationCoordinate2DMake(routePointAnnotation.coordinate.latitude, routePointAnnotation.coordinate.longitude);
        //                       coordinates[1] = CLLocationCoordinate2DMake(_mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
        //
        //                       // Create our polyline with the formatted coordinates array
        //                       MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:2];
        //                       polyline.title = @"Путь до первой точки";
        //
        //                       // Add the polyline to the map, back on the main thread
        //                       // Use weak reference to self to prevent retain cycle
        //                       __weak typeof(self) weakSelf = self;
        //                       dispatch_async(dispatch_get_main_queue(), ^(void)
        //                                      {
        //                                          NSLog(@"Polyline        : %@", currentPolyline);
        ////                                          [weakSelf.mapView removeAnnotation:currentPolyline];
        //                                          [weakSelf.mapView addAnnotation:polyline];
        //                                          if (currentPolyline) {
        ////                                              for (id<MGLAnnotation> annot in weakSelf.mapView.annotations) {
        ////                                                  if ([annot isKindOfClass:[MGLPolyline class]]) {
        ////                                                      MGLPolyline *polyL = (MGLPolyline *)annot;
        ////                                                      if ([polyL isEqual:currentPolyline]) {
        ////                                                          NSLog(@"removed");
        ////                                                          [weakSelf.mapView removeAnnotation:annot];
        ////                                                      }
        ////                                                  }
        ////                                              }
        //                                              [weakSelf.mapView removeAnnotation:currentPolyline];
        //                                          }
        //                                              currentPolyline = polyline;
        //                                          NSLog(@"Polylines in view: %@\n\n", weakSelf.mapView.annotations);
        //
        ////                                          [weakSelf.mapView addAnnotation:currentPolyline];
        ////                                          [weakSelf.mapView showAnnotations:@[currentPolyline] animated:NO];
        //                                      });
        //                   });
    }
    CLLocationCoordinate2D coordinates[] = {
        routePointAnnotation.coordinate,
        _mapView.userLocation.coordinate
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    
    if (self.mapView.annotations.count > 1) {
        [self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    }
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates
                                                           count:numberOfCoordinates];
    [self.mapView addAnnotation:polyline];
}
- (int)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude
                                                  longitude:_mapView.userLocation.coordinate.longitude];
    return [loc2 distanceFromLocation:loc1];
}
+ (CLLocationCoordinate2D)midpointBetweenCoordinate:(CLLocationCoordinate2D)c1 andCoordinate:(CLLocationCoordinate2D)c2
{
    c1.latitude = ToRadian(c1.latitude);
    c2.latitude = ToRadian(c2.latitude);
    CLLocationDegrees dLon = ToRadian(c2.longitude - c1.longitude);
    CLLocationDegrees bx = cos(c2.latitude) * cos(dLon);
    CLLocationDegrees by = cos(c2.latitude) * sin(dLon);
    CLLocationDegrees latitude = atan2(sin(c1.latitude) + sin(c2.latitude), sqrt((cos(c1.latitude) + bx) * (cos(c1.latitude) + bx) + by*by));
    CLLocationDegrees longitude = ToRadian(c1.longitude) + atan2(by, cos(c1.latitude) + bx);
    
    CLLocationCoordinate2D midpointCoordinate;
    midpointCoordinate.longitude = ToDegrees(longitude);
    midpointCoordinate.latitude = ToDegrees(latitude);
    
    return midpointCoordinate;
}

- (void)tableViewSetup {
    self.tableView.backgroundColor = [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RouteInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"feedbackCell"];
}
#pragma mark - MGLMapView delegate methods
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return NO;
}
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
    dispatch_once(&token, ^{
        [self adjustCamera];
    });
    [self drawPolyline];
    _subtitleLabel.text = _mapSubtitleLabel.text = [NSString stringWithFormat:@"До начала маршрута %iм",
                                                    [self distanceFromCoordinate:routePointAnnotation.coordinate]];
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

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + _route.feedbacks.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [RouteInfoTableViewCell heightForRoute:_route];
    } else {
        return [FeedbackTableViewCell heightForFeedback:[_route.feedbacks objectAtIndex:indexPath.row - 1]];
    }
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RouteInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        if (cell == nil) {
            cell = [[RouteInfoTableViewCell alloc] init];
        }
        [cell configureWithRoute:_route];
        return cell;
    } else {
        FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
        if (cell == nil) {
            cell = [[FeedbackTableViewCell alloc] init];
        }
        [cell configureWithFeedback:[_route.feedbacks objectAtIndex:indexPath.row - 1]];
        return cell;
    }
}

#pragma mark - Rotation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    NSLog(@"ROTATED! TableView height: %f", _tableView.frame.size.height);
    [self adjustCamera];
}

#pragma mark - Point View Controller

- (void)pushPointViewControllerWithAnnotation:(RoutePointAnnotation *)annotation {
    
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PointViewController *pointVC = [[PointViewController alloc] init];
    [pointVC configureWithRoutePoint:routePointAnnotation.routePoint];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:pointVC animated:YES completion:nil];
    
//    UINavigationController *navVC = [[FixedNavigationViewController alloc] initWithRootViewController:pointVC];
//    navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:navVC animated:YES completion:nil];

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
