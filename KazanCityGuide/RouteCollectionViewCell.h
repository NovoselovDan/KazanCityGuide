//
//  RouteCollectionViewCell.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface RouteCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) Route *route;

- (void)configureWithRoute:(Route *)route;

@end
