//
//  RouteCollectionViewCell.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "RouteCollectionViewCell.h"

@interface RouteCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *timerView;
@property (nonatomic, strong) UIImageView *distanceView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *distanceLabel;


@end


@implementation RouteCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:100 alpha:0.5].CGColor;
        self.layer.borderWidth = 1.0;
        
        
        //Image View
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_imageView];
        
        //Title
        CGFloat wSize = 144.0;
        CGFloat hSize = 13.0;
        _title = [[UILabel alloc] initWithFrame:CGRectMake(8, self.bounds.size.height - hSize - 37, wSize, hSize)];
        _title.font = [UIFont fontWithName:@".SFUIDisplay-Semibold" size:11.0];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
        //Time
        wSize = 21.0; hSize = 21.0;
        _timerView = [[UIImageView alloc] initWithFrame:CGRectMake(8, self.bounds.size.height - hSize - 8, wSize, hSize)];
        [_timerView setImage:[UIImage imageNamed:@"Timer"]];
        [self addSubview:_timerView];
        
        wSize = 42.0; hSize = 13.0;
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timerView.frame.origin.x + _timerView.bounds.size.width + 5,
                                                                self.bounds.size.height - hSize - 11.0,
                                                                wSize, hSize)];
        _timerLabel.font = [UIFont fontWithName:@".SFUIDisplay-Heavy" size:11.0];
        _timerLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timerLabel];
        
        //Distance
        wSize = 17.0; hSize = 21.0;
        _distanceView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 + 8,
                                                                      self.bounds.size.height - hSize - 8,
                                                                      wSize, hSize)];
        [_distanceView setImage:[UIImage imageNamed:@"Distance"]];
        [self addSubview:_distanceView];
        
        wSize = 41.0; hSize = 13.0;
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_distanceView.frame.origin.x + _distanceView.bounds.size.width + 5,
                                                                   self.bounds.size.height - hSize - 11.0,
                                                                   wSize, hSize)];
        _distanceLabel.font = [UIFont fontWithName:@".SFUIDisplay-Heavy" size:11.0];
        _distanceLabel.textColor = [UIColor whiteColor];
        [self addSubview:_distanceLabel];
    }
    return self;
}

-(void)configureWithRoute:(Route *)route {
    _route = route;
    [_imageView setImage:_route.image];
    _title.text = _route.title;
    _timerLabel.text = _route.time;
    _distanceLabel.text = _route.distance;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    [_imageView setImage:nil];
    _route = nil;
    _timerLabel.text = nil;
    _distanceLabel.text = nil;
}

@end
