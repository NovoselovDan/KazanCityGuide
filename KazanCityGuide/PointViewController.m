//
//  PointViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "PointViewController.h"

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
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    view.backgroundColor = [UIColor yellowColor];
//    view.accessibilityIdentifier = @"my view 1";
//    [self.view addSubview:view];
//    
//    view = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
//    view.backgroundColor = [UIColor greenColor];
//    view.accessibilityIdentifier = @"my view 2";
//    [self.view addSubview:view];
}

- (void)configureWithRoutePoint:(RoutePoint *)routePoint {
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
    bgButton.backgroundColor = [UIColor clearColor];
//    [bgButton setAlpha:0.0];
    bgButton.frame = [UIScreen mainScreen].bounds;
    [bgButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDragInside];
    
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
    
    [self.view insertSubview:bgButton atIndex:0];
    bgButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgButton]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bgButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[bgButton]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(bgButton)]];
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
    
    //Text block
    
    //Action button
    CGFloat height = 50.0;
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0, popupView.bounds.size.height - height, popupView.bounds.size.width, height);
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setTitle:@"Задание" forState:UIControlStateNormal];
    [actionButton setTitleColor:[UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0] forState:UIControlStateNormal];
    actionButton.titleLabel.bounds = CGRectMake(0, 0, 140, 20);
//    actionButton.titleLabel.text = @"Задание";
    actionButton.titleLabel.textColor = [UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0];
    actionButton.titleLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:17.0];
    actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1, 0, actionButton.frame.size.width - 2, 1)];
    line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [actionButton addSubview:line];
    
    [popupView addSubview:actionButton];
    
}

- (UIColor *)tintColor {
    return [UIColor whiteColor];
}

- (CGFloat)textBlockHeight {
    CGFloat height = 0;
    
    return height;
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
