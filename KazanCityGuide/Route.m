//
//  Route.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "Route.h"

@implementation Route

-(id)firstPoint {
    if (_points.count > 0) {
        return [_points firstObject];
    }
    return nil;
}
@end
