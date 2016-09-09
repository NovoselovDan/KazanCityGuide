//
//  RoutePointAnnotation.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "RoutePointAnnotation.h"

@implementation RoutePointAnnotation
-(instancetype)initWithRoutePoint:(RoutePoint *)routePoint {
    self = [super init];
    if (self) {
        self.title = routePoint.title;
        self.coordinate = routePoint.coord;
        self.routePoint = routePoint;
        return self;
    }
    return nil;
}
@end
