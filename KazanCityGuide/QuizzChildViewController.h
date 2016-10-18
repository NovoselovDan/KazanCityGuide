//
//  QuizzChildViewController.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 18.10.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizzChildViewController : UIViewController

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithIndex:(NSInteger) index text:(NSString *)text image:(UIImage *)image;


@end
