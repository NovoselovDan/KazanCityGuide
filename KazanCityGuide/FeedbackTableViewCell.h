//
//  FeedbackTableViewCell.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteFeedback.h"

@interface FeedbackTableViewCell : UITableViewCell

- (void)configureWithFeedback:(RouteFeedback *)feedback;
+ (CGFloat)heightForFeedback:(RouteFeedback *)feedback;

@end
