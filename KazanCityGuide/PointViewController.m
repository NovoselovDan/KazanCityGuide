//
//  PointViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "PointViewController.h"
#import "RoutePointAnnotation.h"

@interface PointViewController () <UIGestureRecognizerDelegate>

//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *textBlockLabel;
//@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) RoutePoint *routePoint;
@end

@implementation PointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureWithRoutePoint:(RoutePoint *)routePoint {
    _routePoint = routePoint;
    self.view.backgroundColor = [UIColor clearColor];
    [self addBlurBackground];
    [self buildInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will appear subviews: %@", self.view.subviews);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addBlurBackground {
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
//    [bgButton setAlpha:0.0];
    bgButton.frame = [UIScreen mainScreen].bounds;
    [bgButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBlurEffect *blurEffcet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffView = [[UIVisualEffectView alloc] initWithEffect:blurEffcet];
    blurEffView.frame = self.view.bounds;
    blurEffView.userInteractionEnabled = NO;
    {
//    [blurEffView setAlpha:0.9];
    [bgButton addSubview:blurEffView];
    blurEffView.translatesAutoresizingMaskIntoConstraints = NO;
    [bgButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurEffView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(blurEffView)]];
    [bgButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurEffView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(blurEffView)]];
    }
    
//    [self.view insertSubview:bgButton atIndex:0];
    [self.view addSubview:bgButton];
    bgButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgButton]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bgButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[bgButton]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bgButton)]];

//    [self.view insertSubview:bgButton atIndex:0];
//    [UIView animateWithDuration:0.1 animations:^{
//        [bgButton setAlpha:1.0];
//    }];
//    [self.view updateConstraintsIfNeeded];
//    [self.view reloadInputViews];
    
}

- (void)buildInterface {
    //UIScrollview
    CGFloat padding = 44.0;
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(padding, 64,
                                                                          [UIScreen mainScreen].bounds.size.width - padding*2,
                                                                          [UIScreen mainScreen].bounds.size.height - padding - 64)];
    popupView.layer.cornerRadius = 8.0;
    popupView.layer.masksToBounds = YES;
    popupView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    popupView.layer.borderWidth = 1.0;
    popupView.backgroundColor = [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
    

    [self.view addSubview:popupView];
    popupView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[popupView]-(padding)-|"
//                                                                      options:0
//                                                                      metrics:@{@"padding" : [NSNumber numberWithDouble:padding]}
//                                                                        views:NSDictionaryOfVariableBindings(popupView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[popupView(==350)]-(padding)-|"
//                                                                      options:NSLayoutFormatAlignAllCenterY
//                                                                      metrics:@{@"padding" : [NSNumber numberWithInt:([UIScreen mainScreen].bounds.size.height - 350)/2]}
//                                                                        views:NSDictionaryOfVariableBindings(popupView)]];
    
    
    //Title
    CGFloat titleHeight = 40.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                    popupView.frame.size.width,
                                                                    titleHeight)];
    titleLabel.text = _routePoint.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [popupView addSubview:titleLabel];
    
    //Top Divide line
    padding = 8;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(padding, titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                               popupView.frame.size.width - padding*2, 1)];
    topLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [popupView addSubview:topLine];

    //Action button
    CGFloat buttonHeight = 50.0;
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0, popupView.bounds.size.height - buttonHeight, popupView.bounds.size.width, buttonHeight);
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setTitle:@"Далее" forState:UIControlStateNormal];
    [actionButton setTitleColor:[UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0] forState:UIControlStateNormal];
    actionButton.titleLabel.bounds = CGRectMake(0, 0, 140, 20);
    actionButton.titleLabel.textColor = [UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [actionButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1, 0, actionButton.frame.size.width - 2, 1)];
    line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [actionButton addSubview:line];

    [popupView addSubview:actionButton];
    
    //Text block
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, topLine.frame.origin.y + 1,
                                                                        popupView.frame.size.width - padding*2,
                                                                        popupView.frame.size.height - buttonHeight - titleHeight)];
    textView.text = _routePoint.text;
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    textView.textAlignment = NSTextAlignmentJustified;
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    
    [popupView addSubview:textView];
}

- (UIColor *)tintColor {
    return [UIColor whiteColor];
}

#pragma mark - UIGestureRecognizer Delegate methods 

- (void)handleBackgroundTouch:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Recognizer view: \t%@\nRecognizer superview: \t%@", recognizer.view.restorationIdentifier, recognizer.view.superview);
    NSLog(@"Background touch Handling!");
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    NSLog(@"location: %@", NSStringFromCGPoint(location));
}

- (void)buttonPressed {
    {
//    NSLog(@"BUTTON PRESSED");
//    UIButton *button;
//    for (id obj in self.view.subviews) {
//        if ([obj isKindOfClass:[UIButton class]]) {
//            button = (UIButton *)obj;
//        }
//    }
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = button.frame;
//        if (frame.size.width < 300)
//            frame.size = CGSizeMake(frame.size.width*2, frame.size.height*2);
//        else
//            frame.size = CGSizeMake(20, 20);
//        frame.origin = CGPointMake(self.view.frame.size.width/2 - frame.size.width/2, frame.origin.y);
//        button.frame = frame;
//        [button setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
//    } completion:^(BOOL finished) {
//        
//    }];
    }
    NSLog(@"Parent VC: %@", self.parentViewController);
    NSLog(@"Dismissing Point View Controller");
    [_detailVC openNextRoutePoint];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
