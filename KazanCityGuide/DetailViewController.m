//
//  DetailViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
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

typedef NS_ENUM(NSInteger, RoutingState) {
    Stopped,
    Started,
    Ended
};

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

@property (strong, nonatomic) UIView *hintAnnotationView;

@end


@implementation DetailViewController {
    dispatch_once_t token;
    NSArray *mapComponents, *detailComponents;
    RoutePointAnnotation *currentRoutePointAnnotation;
    RouteHintAnnotation *currentHintAnnotation;
    MGLPolyline *currentPolyline;
    //Route handling
    int currentPointIndex;
    BOOL pointViewShowed;
    BOOL canShowAnnotationView;
    RoutingState state;
}
- (void)configureWithRoute:(Route *)route {
    _route = route;
    currentRoutePointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    currentPointIndex = (_route.points.count > 0) ? 0 : -1;
    pointViewShowed = NO;
    canShowAnnotationView = NO;
    state = Stopped;
    _hintAnnotationView = nil;
    
    NSLog(@"DetailVC configuring completed!: %@", _route);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    token = 0;
    
    _subtitleLabel.font = _mapSubtitleLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
    _subtitleLabel.textColor = _mapSubtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    _taskLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    _taskLabel.textColor = [self tintColor];
    _taskLabel.shadowColor = [UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0];
    _taskLabel.text = @"Следуйте к следующему месту";
    
    mapComponents = @[_exitButton, _taskLabel, _mapSubtitleLabel, _centerButton, _plusButton, _minusButton];
    detailComponents = @[_okButton, _subtitleLabel, _tableView];
    
    if (!_mapView.hidden) {
        for (UIView *view in mapComponents) {
            [view setHidden:YES];
            [view setAlpha:0.0];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (state == Stopped) {
        NSLog(@"Hello vc");
        [self navigationItemSetup];
        [self mapViewSetup];
        [self tableViewSetup];
    }
    NSLog(@"View will appear!!!");
    pointViewShowed = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okPressed:(id)sender {
    [self hideMenuElements];
    state = Started;
}
- (IBAction)exitPressed:(id)sender {
    [self hideAnnotation];
    [self showMenuElements];
    state = Stopped;
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
//    [self pushPointViewControllerWithAnnotation:routePointAnnotation];
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
//    _mapView.userInteractionEnabled = NO;
    _mapView.zoomEnabled = NO;
    _mapView.zoomLevel = 8.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
    [_mapView.attributionButton setAlpha:0.0];
    [_mapView.logoView setAlpha:0.5];

    RoutePointAnnotation *pointAnnotation = currentRoutePointAnnotation;
    _mapView.centerCoordinate = pointAnnotation.coordinate;
    [self addToMapRoutePointAnnotation:pointAnnotation];
    
}
- (void)addToMapRoutePointAnnotation:(RoutePointAnnotation *)pointAnnotation {
    [_mapView addAnnotation:pointAnnotation];
    
    if (pointAnnotation.routePoint.hints.count > 0) {
        for (RouteHintAnnotation *hintAnnotation in pointAnnotation.routePoint.hints) {
            [_mapView addAnnotation:hintAnnotation];
        }
    }
}
- (void)adjustCamera {
    [_mapView resetNorth];
    CLLocationDistance distance = [self distanceFromCoordinate:currentRoutePointAnnotation.coordinate];
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
    CLLocationCoordinate2D midpoint = [[self class] midpointBetweenCoordinate:currentRoutePointAnnotation.coordinate
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
        currentRoutePointAnnotation.coordinate,
        _mapView.userLocation.coordinate
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    NSLog(@"mapView annotations count: %lu", _mapView.annotations.count);
    if (self.mapView.annotations.count > 1) {
        for (id<MGLAnnotation> ann in self.mapView.annotations) {
            if ([ann isKindOfClass:[MGLPolyline class]]) {
                MGLPolyline *polyline =(MGLPolyline *) ann;
                if ([polyline.title isEqualToString:@"direction"]) {
                    [self.mapView removeAnnotation:ann];
                }
            }
        }
//        [self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    }
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates
                                                           count:numberOfCoordinates];
    polyline.title = @"direction";
    [self.mapView addAnnotation:polyline];
}
- (float)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate {
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

- (void)hideMenuElements {
//    _mapView.userInteractionEnabled = YES;
    _mapView.zoomEnabled = YES;
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
- (void)showMenuElements {
//    _mapView.userInteractionEnabled = NO;
    _mapView.zoomEnabled = NO;
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


-(void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - Route handling
- (void)openNextRoutePoint {
    if (currentPointIndex < _route.points.count - 1) {
        currentPointIndex+=1;
        currentRoutePointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route.points objectAtIndex:currentPointIndex]];
        [self addToMapRoutePointAnnotation:currentRoutePointAnnotation];
        [_mapView addAnnotation:currentRoutePointAnnotation];
        [self drawPolyline];
        [self drawPath];
        canShowAnnotationView = YES;
        pointViewShowed = NO;
    } else {
        state = Ended;
        currentRoutePointAnnotation = nil;
        [self drawPath];
    }
    NSLog(@"State: %li", (long)state);
}
- (void)drawPath {
    NSMutableArray *routePtAnnotations = [NSMutableArray new];
    for (id<MGLAnnotation> ann in self.mapView.annotations) {
        if ([ann isKindOfClass:[MGLPolyline class]]) {
            MGLPolyline *polyline =(MGLPolyline *) ann;
            if ([polyline.title isEqualToString:@"path"]) {
                [self.mapView removeAnnotation:ann];
            }
//        } else if ([ann isKindOfClass:[RoutePointAnnotation class]] && ![ann isEqual:currentRoutePointAnnotation]) {
        } else if ([ann isKindOfClass:[RoutePointAnnotation class]]) {
            [routePtAnnotations addObject:ann];
        }
    }
    
    CLLocationCoordinate2D coordinates[routePtAnnotations.count];
    for (int i=0; i < routePtAnnotations.count; i++) {
        RoutePointAnnotation *ann = routePtAnnotations[i];
        coordinates[i] = ann.coordinate;
    }
    
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates
                                                           count:numberOfCoordinates];
    polyline.title = @"path";
    [self.mapView addAnnotation:polyline];
}

#pragma mark - MGLMapView delegate methods
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
//    RoutePointAnnotation *routeAnnotation = (RoutePointAnnotation *)annotation;
//    if ([routeAnnotation isEqual:currentRoutePointAnnotation]) {
//        NO;
//    }
//    return YES;
    return NO;
}
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
    dispatch_once(&token, ^{
        [self adjustCamera];
    });
    
    [self drawPolyline];
    //map Subtitle Label update
    float distance = [self distanceFromCoordinate:currentRoutePointAnnotation.coordinate];
    _subtitleLabel.text = _mapSubtitleLabel.text = [NSString stringWithFormat:@"До %@ точки %.1fм",
                                                    (currentPointIndex == 0)?@"начальной":@"следующей",
                                                    distance];
    //hint annotations check
    NSLog(@"searching hint annotation");
    for (id<MGLAnnotation> ann in _mapView.annotations) {
        if ([ann isKindOfClass:[RouteHintAnnotation class]]) {
//            NSLog(@"FAOUNDOOOD HINT ANNOTATION AT THE MAP!");
            RouteHintAnnotation *hintAnnotation = ann;
            float distanceToHint = [self distanceFromCoordinate:hintAnnotation.coordinate];
            if (distanceToHint < hintAnnotation.activeRadius) {
                if (canShowAnnotationView) {
                    [self showAnnotation:hintAnnotation];
                }
            } else if (distanceToHint >= hintAnnotation.activeRadius && [hintAnnotation isEqual:currentHintAnnotation]) {
                [self hideAnnotation];
            }
        }
    }
    //Route Point reaching check
    if (distance < currentRoutePointAnnotation.routePoint.reachRadius && !pointViewShowed && state == Started) {
        [self pushPointViewControllerWithAnnotation:currentRoutePointAnnotation];
        pointViewShowed = YES;
        canShowAnnotationView = YES;
    }
}
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    // This example is only concerned with point annotations.
    NSLog(@"view for annotaion: class = %@", [annotation class]);
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[RouteHintAnnotation class]]) {
        NSLog(@"view for annotaion: Route Hint Annotation found");
        MGLAnnotationView *annV = [[MGLAnnotationView alloc] init];
        annV.hidden = YES;
        return annV;
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
//
//        if ([annotation isEqual:currentRoutePointAnnotation]) {
//            annotationView.backgroundColor = [UIColor colorWithHue:hue saturation:0.5 brightness:1 alpha:1];
//        } else {
//            annotationView.backgroundColor = [UIColor grayColor];
//        }
    }
    
    return annotationView;
}
- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    if ([annotation isKindOfClass:[MGLPolyline class]]) {
        return 0.5;
    }
    return 1;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    if ([annotation.title isEqualToString:@"path"])
    {
        // Mapbox cyan
//        return [UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
        return [UIColor darkGrayColor];
    }
    else {
        return [UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
    }
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
        NSLog(@"Height for row at index path... height for info");
        return [RouteInfoTableViewCell heightForRoute:self.route];
    } else {
        NSLog(@"Height for row at index path... height for feedback");
        return [FeedbackTableViewCell heightForFeedback:[_route.feedbacks objectAtIndex:indexPath.row - 1]];
    }
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell for row at index path..");
    if (indexPath.row == 0) {
        RouteInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        if (cell == nil) {
            cell = [[RouteInfoTableViewCell alloc] init];
        }
        [cell configureWithRoute:_route];
        NSLog(@"returning infoCell");
        return cell;
    } else {
        FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
        if (cell == nil) {
            cell = [[FeedbackTableViewCell alloc] init];
        }
        NSLog(@"configuring feedbackCell");
        [cell configureWithFeedback:[_route.feedbacks objectAtIndex:indexPath.row - 1]];
        NSLog(@"returning feedbackCell");
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
    [pointVC configureWithRoutePoint:currentRoutePointAnnotation.routePoint];
    pointVC.detailVC = self;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:pointVC animated:YES completion:nil];
    
    
//    UINavigationController *navVC = [[FixedNavigationViewController alloc] initWithRootViewController:pointVC];
//    navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:navVC animated:YES completion:nil];

}

#pragma mark - Hint Annotations 
CGFloat hintWidth = 270.0;
CGFloat padding = 8.0;

- (void)showAnnotation:(RouteHintAnnotation *)hint {
    canShowAnnotationView = NO;
    currentHintAnnotation = hint;
    
    NSLog(@"_hintAnnotationView: %@", _hintAnnotationView);
    
    if (_hintAnnotationView) {
        UIView *hintV;
        for (UIView *subview in self.view.subviews) {
            if ([subview isEqual:_hintAnnotationView]) {
                NSLog(@"hint subview founded");
                hintV = subview;
            }
        }
        NSLog(@"Hiding Annotation");
        [UIView animateWithDuration:0.2
                              delay:0
             usingSpringWithDamping:5.0f
              initialSpringVelocity:50.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = hintV.frame;
                             frame.origin.y = -10 - frame.size.height;
                             hintV.frame = frame;
                             
                             _taskLabel.hidden = NO;
                         } completion:^(BOOL finished) {
                             //Showing new hint;
                             UIView *hintV = [DetailViewController getHintAnnotationViewWith:currentHintAnnotation.text];
                             hintV.center = self.view.center;
                             CGRect frame = hintV.frame;
                             frame.origin.y = 0 - frame.size.height;
                             hintV.frame = frame;
                             
                             _hintAnnotationView = nil;
                             [self.view addSubview:hintV];
                             [UIView animateWithDuration:0.8
                                                   delay:0
                                  usingSpringWithDamping:3.0f
                                   initialSpringVelocity:30.0f
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  
                                                  
                                                  CGRect frame = hintV.frame;
                                                  frame.origin.y = 30;
                                                  hintV.frame = frame;
                                                  
                                                  _taskLabel.hidden = YES;
                                              } completion:^(BOOL finished) {
                                                  _hintAnnotationView = hintV;
                                                  [self vibrate];
                                              }];
                         }];
    } else {
        UIView *hintV = [DetailViewController getHintAnnotationViewWith:currentHintAnnotation.text];
        hintV.center = self.view.center;
        CGRect frame = hintV.frame;
        frame.origin.y = 0 - frame.size.height;
        hintV.frame = frame;
        
        [self.view addSubview:hintV];
        [UIView animateWithDuration:0.8
                              delay:0
             usingSpringWithDamping:3.0f
              initialSpringVelocity:30.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             
                             CGRect frame = hintV.frame;
                             frame.origin.y = 30;
                             hintV.frame = frame;
                             
                             _taskLabel.hidden = YES;
                         } completion:^(BOOL finished) {
                             _hintAnnotationView = hintV;
                             [self vibrate];
                         }];
    }
}
- (void)hideAnnotation {
    if (_hintAnnotationView) {
        UIView *hintV = nil;
        for (UIView *subview in self.view.subviews) {
            if ([subview isEqual:_hintAnnotationView]) {
                NSLog(@"hint subview founded");
                hintV = subview;
            }
        }
        
        [UIView animateWithDuration:0.8
                              delay:0
             usingSpringWithDamping:5.0f
              initialSpringVelocity:30.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = hintV.frame;
                             frame.origin.y = -10 - frame.size.height;
                             hintV.frame = frame;
                             
                             _taskLabel.hidden = NO;
                         } completion:^(BOOL finished) {
                             _hintAnnotationView = nil;
                             canShowAnnotationView = YES;
                         }];
    }
}

+ (UIView *)getHintAnnotationViewWith:(NSString *)text {
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, hintWidth, [self heightForText:text])];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.text = text;
    hintLabel.lineBreakMode = NSLineBreakByWordWrapping;
    hintLabel.numberOfLines = 0;
    hintLabel.font = [self annotationFont];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, hintWidth + 2*padding, hintLabel.bounds.size.height + 2*padding)];
    hintView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    hintView.layer.cornerRadius = 10.0;
    hintView.layer.masksToBounds = YES;
    [hintView addSubview:hintLabel];
    
    return hintView;
}

+ (CGFloat)heightForText:(NSString *)text {
    CGSize constraint = CGSizeMake(hintWidth , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : [self annotationFont] }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
}
+ (UIFont *)annotationFont {
    return [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
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
