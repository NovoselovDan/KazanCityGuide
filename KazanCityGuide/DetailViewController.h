//
//  DetailViewController.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface DetailViewController : UIViewController

- (void)configureWithRoute:(Route *)route;

@end
