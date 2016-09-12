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
#import "RouteInfoTableViewCell.h"
#import "FeedbackTableViewCell.h"
@import Mapbox;

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
}
- (void)configureWithRoute:(Route *)route {
    _route = route;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self mapViewSetup];
    [self tableViewSetup];
    
    _subtitleLabel.font = _mapSubtitleLabel.font = [UIFont fontWithName:@".SFUIText-Semibold" size:10.0];
    _subtitleLabel.textColor = _mapSubtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    _taskLabel.font = [UIFont fontWithName:@".SFUIText-Medium" size:17.0];
    _taskLabel.textColor = [self tintColor];
    _taskLabel.shadowColor = [UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0];
    mapComponents = @[_exitButton, _taskLabel, _mapSubtitleLabel, _centerButton, _plusButton, _minusButton];
    detailComponents = @[_okButton, _subtitleLabel, _tableView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationItemSetup];
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
    _taskLabel.text = @"Следуйте к следующему месту";
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
                     }];
}
- (IBAction)exitPressed:(id)sender {
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
                     }];
}
- (IBAction)centerPressed:(id)sender {
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:_mapView.camera.centerCoordinate.latitude
                                                  longitude:_mapView.camera.centerCoordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude
                                                  longitude:_mapView.userLocation.coordinate.longitude];
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:_mapView.userLocation.coordinate
                                                            fromDistance:_mapView.camera.altitude
                                                                   pitch:0
                                                                 heading:0];
    if (distance < 10000)
        [_mapView flyToCamera:camera completionHandler:nil];
    else
        [_mapView setCamera:camera animated:NO];
}
- (IBAction)plusPresse:(id)sender {
    [_mapView setZoomLevel:_mapView.zoomLevel+0.5 animated:YES];
}
- (IBAction)minusPressed:(id)sender {
    [_mapView setZoomLevel:_mapView.zoomLevel-0.5 animated:YES];
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
    
    RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    _mapView.centerCoordinate = pointAnnotation.coordinate;
    _mapView.zoomLevel = 8.8;
    _mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/dark-v9"];
    //    _mapView.userInteractionEnabled = NO;
    
    [_mapView addAnnotation:pointAnnotation];
}
- (void)adjustCamera {
    CLLocationDistance distance = [self distance];
    
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
- (int)distance {
    RoutePointAnnotation *pointAnnotation = [[RoutePointAnnotation alloc] initWithRoutePoint:[_route firstPoint]];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:pointAnnotation.coordinate.latitude
                                                  longitude:pointAnnotation.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude
                                                  longitude:_mapView.userLocation.coordinate.longitude];
    return [loc2 distanceFromLocation:loc1];
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
        [self drawPolyline];
    });
    _subtitleLabel.text = _mapSubtitleLabel.text = [NSString stringWithFormat:@"До начала маршрута %iм", [self distance]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
