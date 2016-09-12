//
//  FeedbackTableViewCell.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "RatingVIew.h"

@interface FeedbackTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet RatingVIew *ratingView;

@end

@implementation FeedbackTableViewCell
+ (CGFloat)heightForFeedback:(RouteFeedback *)feedback {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = screenWidth - 28*2;
    CGFloat height = 0;
    
    height += 26.0;
    height += [self getHeightForText:feedback.text withFont:[UIFont fontWithName:@".SFUIText-Regular" size:12.0] andWidth:width];
    height += 19;
    height += 20;
    
    return height;
}
+(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
}

- (void)configureWithFeedback:(RouteFeedback *)feedback {
    _nameLabel.text = feedback.name;
    _textLbl.text = feedback.text;
    _dateLabel.text = feedback.date;
//    [self setRatingView:[[RatingVIew alloc] initWithRating:feedback.rating]];
    [_ratingView setRating:feedback.rating];
}
- (void)designSetup {
    self.backgroundColor = [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
//    self.layer.cornerRadius = 8.0;
//    self.layer.masksToBounds = YES;
    
    _baseView.layer.cornerRadius = 8.0;
    _baseView.layer.masksToBounds = YES;
    
    _nameLabel.font = [UIFont fontWithName:@".SFUIText-Bold" size:15.0];
    _nameLabel.textColor = [UIColor colorWithHue:240.0/360.0 saturation:0.02 brightness:0.96 alpha:1.0];
    
    _textLbl.font = [UIFont fontWithName:@".SFUIText-Regular" size:12.0];
    _textLbl.textColor = [UIColor colorWithHue:240.0/360.0 saturation:0.02 brightness:0.96 alpha:1.0];
    _textLbl.textAlignment = NSTextAlignmentJustified;
    _textLbl.numberOfLines = 0;
    
    _dateLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:9.0];
    _dateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"Text frame: %@", NSStringFromCGRect(_textLbl.frame));
    [self designSetup];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    _nameLabel.text = nil;
    _textLbl.text = nil;
    _dateLabel.text = nil;
}

@end
