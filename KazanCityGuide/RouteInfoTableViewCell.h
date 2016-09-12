//
//  RouteInfoTableViewCell.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface RouteInfoTableViewCell : UITableViewCell

- (void)configureWithRoute:(Route *)route;
- (CGFloat)height;
+ (CGFloat)heightForRoute:(Route *)route;
@end
