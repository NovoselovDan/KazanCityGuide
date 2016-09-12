//
//  Route.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RouteTag) {
    None,
    New,
    Popular
};

@interface Route : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSNumber *rate;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *points;
@property (strong, nonatomic) NSArray *feedbacks;
@property (assign, nonatomic) RouteTag tag;

- (id)firstPoint;
@end

