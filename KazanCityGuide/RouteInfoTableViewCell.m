//
//  RouteInfoTableViewCell.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "RouteInfoTableViewCell.h"

@interface RouteInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *timeSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *distanceSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *ratingSubtitle;

@property (strong, nonatomic) Route *route;
@end

@implementation RouteInfoTableViewCell
+ (CGFloat)heightForRoute:(Route *)route {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 0;
    height = 90;
    int width = screenWidth - 8*2;
//    UIFont *font = [UIFont fontWithName:@".SFUIText-Regular" size:15.0];
    UIFont *font = [UIFont systemFontOfSize:15.0];
    NSLog(@"font: %@", font);
    float textHeight = [self getHeightForText:route.text
                                     withFont:font
                                     andWidth:width];
    height +=textHeight;
    height +=18;
    
    NSLog(@"heightForRoute returning Height: %f", height);
    return height;

}
+(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    NSLog(@"getHeightForText...");
////----------------------------------------------------------------------------------------
//    for (NSString *familyName in [UIFont familyNames]){
//        NSLog(@"Family name: %@", familyName);
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"--Font name: %@", fontName);
//        }
//    }
////----------------------------------------------------------------------------------------
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        NSLog(@"font: %@", font);
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:dict
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    NSLog(@"height: %f", height);
    return height;
}


- (void)configureWithRoute:(Route *)route {
    _route = route;
    
    _timeLabel.text = _route.time;
    _distanceLabel.text = _route.distance;
    _ratingLabel.text = _route.rate.stringValue;
    _text.text = _route.text;
}

- (void)designSetup {
    self.backgroundColor = [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
    
    //Labels & Subtitles
    UIFont *labelFont = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
    UIFont *subtitleFont = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    
    _timeLabel.font = labelFont;
    _distanceLabel.font = labelFont;
    _ratingLabel.font = labelFont;
    
    _timeSubtitle.font = subtitleFont;
    _distanceSubtitle.font = subtitleFont;
    _ratingSubtitle.font = subtitleFont;
    
    //Text
    _text.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    _text.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    _text.textAlignment = NSTextAlignmentJustified;
    _text.numberOfLines = 0;
}

#pragma mark - rest
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self designSetup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    _timeLabel.text = nil;
    _distanceLabel.text = nil;
    _ratingLabel.text = nil;
    _text.text = nil;
}

@end
