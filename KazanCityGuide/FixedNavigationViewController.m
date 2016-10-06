//
//  FixedNavigationViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "FixedNavigationViewController.h"
#import "MenuViewController.h"

@interface FixedNavigationViewController ()

@end

@implementation FixedNavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlurBackground];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)addBlurBackground {
    UIBlurEffect *blurEffcet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffView = [[UIVisualEffectView alloc] initWithEffect:blurEffcet];
    blurEffView.frame = self.view.bounds;
    
    [self.view insertSubview:blurEffView atIndex:0];
    
    blurEffView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurEffView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(blurEffView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurEffView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(blurEffView)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // iOS5
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//- (NSUInteger)supportedInterfaceOrientations {
//    if ([self.visibleViewController isKindOfClass:[MenuViewController class]]) {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
