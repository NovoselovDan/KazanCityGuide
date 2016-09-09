//
//  RoutePoint.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import Mapbox;

@interface RoutePoint : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D coord;

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;



@end
