//
//  CustomCalloutView.h
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Mapbox;

@interface CustomCalloutView : UIView <MGLCalloutView>

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation;

@end
