//
//  RouteFeedback.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteFeedback : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger rating;

- (instancetype)initWithName:(NSString *)name Text:(NSString *)text Date:(NSString *)date Rating:(NSInteger )rating;

@end
