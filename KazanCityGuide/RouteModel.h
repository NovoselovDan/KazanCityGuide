//
//  RouteModel.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutePoint.h"
@import Mapbox;

typedef enum {
    NONE,
    NEW,
    POPULAR
}tagType;

@interface RouteModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSNumber *rate;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *points;
@property (assign, nonatomic) tagType tag;

- (instancetype)initWihtName:(NSString *)name
                    Distance:(NSString *)distance
                        Time:(NSString *)time
                        Rate:(NSNumber *)rate
                        Text:(NSString *)text
                       Image:(UIImage *)image
                      Points:(NSArray *)points
                         Tag:(tagType)tag;

- (MGLAnnotationView *)firstPoint;


@end
