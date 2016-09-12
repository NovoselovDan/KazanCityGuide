//
//  RouteFeedback.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "RouteFeedback.h"

@implementation RouteFeedback

- (instancetype)initWithName:(NSString *)name Text:(NSString *)text Date:(NSString *)date Rating:(NSInteger)rating {
    self = [super init];
    if (self) {
        _name = name;
        _text = text;
        _date = date;
        _rating = rating;
    }
    return self;
}

@end
