//
//  CustomCalloutView.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "CustomCalloutView.h"
#import "RoutePointAnnotation.h"

static CGFloat const tipHeight = 10.0;
static CGFloat const tipWidth = 20.0;

@interface CustomCalloutView ()

@property (strong, nonatomic) UIButton *mainBody;

@end

@implementation CustomCalloutView {
    id <MGLAnnotation> _representedObject;
    __unused UIView *_leftAccessoryView;/* unused */
    __unused UIView *_rightAccessoryView;/* unused */
    __weak id <MGLCalloutViewDelegate> _delegate;
    RoutePointAnnotation *pointAnnotation;
}

@synthesize representedObject = _representedObject;
@synthesize leftAccessoryView = _leftAccessoryView;/* unused */
@synthesize rightAccessoryView = _rightAccessoryView;/* unused */
@synthesize delegate = _delegate;

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation {
    self = [super init];
    if (self) {
        pointAnnotation = annotation;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        // Create and add a subview to hold the callout’s text
        UIButton *mainBody = [UIButton buttonWithType:UIButtonTypeCustom];
        mainBody.backgroundColor = [self backgroundColorForCallout];
        mainBody.tintColor = [UIColor whiteColor];
        mainBody.frame = CGRectMake(0, 0, 160, 160);
        mainBody.layer.cornerRadius = 4.0;
        mainBody.layer.masksToBounds = YES;
        mainBody.layer.borderColor = [self backgroundColorForCallout].CGColor;
        mainBody.layer.borderWidth = 1.0;
        self.mainBody = mainBody;

        [self addSubview:self.mainBody];
    }
    
    return self;
}

#pragma mark - MGLCalloutView API

- (void)presentCalloutFromRect:(CGRect)rect inView:(UIView *)view constrainedToView:(UIView *)constrainedView animated:(BOOL)animated
{
    // Do not show a callout if there is no title set for the annotation
//    if (![self.representedObject respondsToSelector:@selector(title)])
//    {
//        return;
//    }
    
    Route *route = pointAnnotation.routePoint.route;
    
    //Img
    [_mainBody setImage:route.image forState:UIControlStateNormal];
    
    //Gradient
    CGFloat gradientHeight = 60.0;
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)[UIColor clearColor].CGColor, (id)[self gradientColor].CGColor, nil];
    theViewGradient.frame = CGRectMake(0, _mainBody.bounds.size.height - gradientHeight, _mainBody.bounds.size.width, gradientHeight);
    
    [_mainBody.layer addSublayer:theViewGradient];
    
    //Text Label View
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 110, 144, 13)];
    textLabel.font = [UIFont fontWithName:@".SFUIDisplay-Semibold" size:11.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = route.title;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    [_mainBody addSubview:textLabel];
    
    //Route Time
    CGFloat wSize = 21.0, hSize = wSize;
    UIImageView *timerView = [[UIImageView alloc] initWithFrame:CGRectMake(8, _mainBody.bounds.size.height - hSize - 8,
                                                                           wSize, hSize)];
    [timerView setImage:[UIImage imageNamed:@"Timer"]];
    [_mainBody addSubview:timerView];
    
    wSize = 42.0; hSize = 13.0;
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(timerView.frame.origin.x + timerView.bounds.size.width + 5,
                                                                    _mainBody.bounds.size.height - hSize - 11.0,
                                                                    wSize, hSize)];
    timerLabel.font = [UIFont fontWithName:@".SFUIDisplay-Heavy" size:11.0];
    timerLabel.textColor = [UIColor whiteColor];
    timerLabel.text = route.time;
    [_mainBody addSubview:timerLabel];
    
    
    //Route Distance
    wSize = 17.0; hSize = 21.0;
    UIImageView *distanceView = [[UIImageView alloc] initWithFrame:CGRectMake(_mainBody.bounds.size.width/2 + 8,
                                                                              _mainBody.bounds.size.height - hSize - 8,
                                                                              wSize, hSize)];
    [distanceView setImage:[UIImage imageNamed:@"Distance"]];
    [_mainBody addSubview:distanceView];
    
    wSize = 41.0; hSize = 13.0;
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(distanceView.frame.origin.x + distanceView.bounds.size.width + 5,
                                                                       _mainBody.bounds.size.height - hSize - 11, wSize, hSize)];
    distanceLabel.font = [UIFont fontWithName:@".SFUIDisplay-Heavy" size:11.0];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.text = route.distance;
    [_mainBody addSubview:distanceLabel];
    

    [view addSubview:self];
    
    // Prepare title label
//    [self.mainBody setTitle:self.representedObject.title forState:UIControlStateNormal];
//    [self.mainBody sizeToFit];
    
    if ([self isCalloutTappable])
    {
        // Handle taps and eventually try to send them to the delegate (usually the map view)
        [self.mainBody addTarget:self action:@selector(calloutTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        // Disable tapping and highlighting
        self.mainBody.userInteractionEnabled = NO;
    }
    
    // Prepare our frame, adding extra space at the bottom for the tip
    CGFloat frameWidth = self.mainBody.bounds.size.width;
    CGFloat frameHeight = self.mainBody.bounds.size.height + tipHeight;
    CGFloat frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0);
    CGFloat frameOriginY = rect.origin.y - frameHeight - 4 ;
    self.frame = CGRectMake(frameOriginX, frameOriginY,
                            frameWidth, frameHeight);
    
    if (animated)
    {
        self.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)dismissCalloutAnimated:(BOOL)animated
{
    if (self.superview)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
}

#pragma mark - Callout interaction handlers

- (BOOL)isCalloutTappable
{
    if ([self.delegate respondsToSelector:@selector(calloutViewShouldHighlight:)]) {
        return [self.delegate performSelector:@selector(calloutViewShouldHighlight:) withObject:self];
    }
    
    return NO;
}

- (void)calloutTapped
{
    if ([self isCalloutTappable] && [self.delegate respondsToSelector:@selector(calloutViewTapped:)])
    {
        [self.delegate performSelector:@selector(calloutViewTapped:) withObject:self];
    }
}

#pragma mark - Custom view styling

- (UIColor *)backgroundColorForCallout {
    return [UIColor colorWithHue:0.0 saturation:0.0 brightness:100 alpha:0.5];
}

- (UIColor *)gradientColor {
    return [UIColor colorWithHue:242.0/360.0 saturation:0.47 brightness:100 alpha:1.0];
}

- (void)drawRect:(CGRect)rect
{
    // Draw the pointed tip at the bottom
    UIColor *fillColor = [self backgroundColorForCallout];
    
    CGFloat tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0);
    CGPoint tipBottom = CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y + rect.size.height);
    CGFloat heightWithoutTip = rect.size.height - tipHeight - 1;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef tipPath = CGPathCreateMutable();
    CGPathMoveToPoint(tipPath, NULL, tipLeft, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, tipBottom.x, tipBottom.y);
    CGPathAddLineToPoint(tipPath, NULL, tipLeft + tipWidth, heightWithoutTip);
    CGPathCloseSubpath(tipPath);
    
    [fillColor setFill];
    CGContextAddPath(currentContext, tipPath);
    CGContextFillPath(currentContext);
    CGPathRelease(tipPath);
}


@end
