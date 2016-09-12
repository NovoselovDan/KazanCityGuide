//
//  RatingVIew.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "RatingVIew.h"

@implementation RatingVIew

- (instancetype)initWithRating:(NSInteger)rating {
    self = [super initWithFrame:CGRectMake(0, 0, 67.0, 10.0)];
    if (self) {
//        NSLog(@"RatingView frame: %@", NSStringFromCGRect(self.frame));
        UIImageView *starImgView;
        for (int i = 0; i < 5; i++) {
            starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0+14*i, 0, 11, 10)];
            [starImgView setImage:[UIImage imageNamed:(i < rating) ? @"StarFilled" : @"StarUnfilled"]];
            [self addSubview:starImgView];
        }
    }
    return self;
}

- (void)setRating:(NSInteger)rating {
//    NSLog(@"RatingView frame: %@", NSStringFromCGRect(self.frame));
    UIImageView *starImgView;
    for (int i = 0; i < 5; i++) {
        starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0+14*i, 0, 11, 10)];
        [starImgView setImage:[UIImage imageNamed:(i < rating) ? @"StarFilled" : @"StarUnfilled"]];
        [self addSubview:starImgView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
