//
//  RoutePointAnnotation.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "RoutePoint.h"

@interface RoutePointAnnotation : MGLPointAnnotation
@property (nonatomic, weak) RoutePoint *routePoint;

- (instancetype)initWithRoutePoint:(RoutePoint *)routePoint;

@end
