//
//  Route.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "Route.h"

@implementation Route

-(instancetype)initWihtName:(NSString *)name Distance:(NSString *)distance Time:(NSString *)time Rate:(NSNumber *)rate Text:(NSString *)text Image:(UIImage *)image Points:(NSArray *)points Tag:(tagType)tag {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(MGLAnnotationView *)firstPoint {
    return [_points firstObject];
}

@end
