//
//  PointViewController.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutePoint.h"
#import "DetailViewController.h"

@interface PointViewController : UIViewController
@property (nonatomic, weak) DetailViewController *detailVC;

- (void)configureWithRoutePoint:(RoutePoint *)routePoint;

@end
