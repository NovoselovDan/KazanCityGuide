//
//  RoutePoint.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
@import CoreLocation;
@import Mapbox;


@interface RoutePoint : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D coord;
@property (assign, nonatomic) float reachRadius;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSArray *hints;
@property (strong, nonatomic) id quizz;
@property (weak, nonatomic) Route *route;

@end
