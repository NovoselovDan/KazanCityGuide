//
//  CustomAnnotationView.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Force the annotation view to maintain a constant size when the map is tilted.
    self.scalesWithViewingDistance = false;
    
    // Use CALayer’s corner radius to turn this view into a circle.
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Animate the border width in/out, creating an iris effect.
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.duration = 0.1;
    self.layer.borderWidth = selected ? 3 : 1;
    [self.layer addAnimation:animation forKey:@"borderWidth"];
    
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
//    animation.duration = 1.0;
//    self.layer.backgroundColor = selected ? [UIColor redColor].CGColor : [UIColor colorWithHue:220/360.0 saturation:0.5 brightness:1.0 alpha:1.0].CGColor;
//    [self.layer addAnimation:anim forKey:@"backgroundColor"];
    
}
@end
