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
    
    MGLPointAnnotation *testPoint = [[MGLPointAnnotation alloc] init];
    testPoint.coordinate = CLLocationCoordinate2DMake(55.782389, 49.129910);
    testPoint.title = @"Test point";
    testPoint.subtitle = [NSString stringWithFormat:@"%f ; %f", testPoint.coordinate.latitude, testPoint.coordinate.longitude];
    
    [_mapView addAnnotation:testPoint];
    
    
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
    
    NSLog(@"AFTER WORK:\nMAP VIEW USER LOCATION: %@", _mapView.showsUserLocation? @"ON" : @"OFF");
}
- (void)GenerateTestModel {
    Route *model = [[Route alloc] init];
    model.title = @"Прогулка по ул. Баумана";
    model.distance = @"0,9км";
    model.time = @"1,5ч";
    model.rate = @4.5;
    model.text = @"Обзорная экскурсия по центральной улице города. Пройдя её Вы ознакомитесь с рядом достопримечательностей Казани, которые в сумме своей и формируют ту неповторимую атмосферу города.";
    model.image = [UIImage imageNamed:@"TestImage"];
    model.tag = None;

    RoutePoint *point = [[RoutePoint alloc] init];
    point.coord = CLLocationCoordinate2DMake(55.787389, 49.121610);
    point.title = @"Часы на ул. Баумана";
    point.text = @"Исәнмесез! Рады видть Вас в Казани! Место на котором Вы находитесь называется \"Площадь имени Габдуллы Тукая\" – названа в честь татарского поэта. Сами казанцы называют эту площадь \"Кольцо\" название повелось оттого, что в своё время в этом месте заканчивался маршрут нескольких трамваев и существовали так называемые разворотные кольца. Ныне трамвайных путей уже не существует, но это название сохранилось и отразилось на названии расположенного через дорогу торгового центра. Сейчас площадь является общественным центром города, местом сосредоточения ряда торговых и развлекательных заведений. Например, одно из расположенных рядом зданий (на нём написано ГУМ), как можно догадаться - это торговый центр. Его объем образован объединением нескольких соседних зданий. Но, не смотря на декор их фасадов, только одно из них является историческим. К слову, когда-то в нём располагался один из лучших ресторанов в городе, конкурировавший с другим, мимо которого Вы ещё пройдёте.";
    point.route = model;
    model.points = [NSArray arrayWithObject:point];
    
    if (!_routes) {
        _routes = [NSArray arrayWithObject:model];
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
    MGLPointAnnotation *ann = annotation;
    NSLog(@"DESELECTION ANNOTATION: %@", ann.title);
    [mapView deselectAnnotation:annotation animated:YES];
    
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
