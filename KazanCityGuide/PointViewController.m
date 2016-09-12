//
//  PointViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "PointViewController.h"

@interface PointViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textBlockLabel;
@property (nonatomic, strong) UIButton *actionButton;

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
    
    //Title
    
    //Text block
    
    //Action button
    
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
