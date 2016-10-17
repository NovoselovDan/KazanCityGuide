//
//  RouteQuizz.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 14.10.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutePoint.h"

@interface RouteQuizz : NSObject

@property (nonatomic, weak) RoutePoint *routePoint;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *imageSet;
@property (nonatomic, assign) NSInteger correctIndex;

@end
