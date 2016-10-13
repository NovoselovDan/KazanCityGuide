//
//  RouteHintAnnotation.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.10.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "RouteHintAnnotation.h"

@implementation RouteHintAnnotation
-(instancetype)initWithRoutePoint:(RoutePoint *)routePoint andCoordinate:(CLLocationCoordinate2D)coord  {
    self = [super init];
    if (self) {
        self.coordinate = coord;
        self.routePoint = routePoint;
        self.activeRadius = 20.0;
        
        return self;
    }
    return nil;
}
@end
