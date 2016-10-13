//
//  RouteHintAnnotation.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.10.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "RoutePoint.h"

@interface RouteHintAnnotation : MGLPointAnnotation
@property (nonatomic, weak) RoutePoint *routePoint;
@property (nonatomic, assign) float actionRadius;
@property (nonatomic, strong) NSString *text;

-(instancetype)initWithRoutePoint:(RoutePoint *)routePoint andCoordinate:(CLLocationCoordinate2D)coord;

@end
