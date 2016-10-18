//
//  PointViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 12.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "PointViewController.h"
#import "RoutePointAnnotation.h"
#import "RouteQuizz.h"

@interface PointViewController () <UIGestureRecognizerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIView *popupView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *actionButton;

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) UITextView *quizzTextView;

@property (nonatomic, strong) RoutePoint *routePoint;
@property (nonatomic, strong) RouteQuizz *routeQuizz;
@end

@implementation PointViewController {
    NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 0;
}

- (void)configureWithRoutePoint:(RoutePoint *)routePoint {
    _routePoint = routePoint;
    if (_routePoint.quizz) {
        _routeQuizz = _routePoint.quizz;
    }
    self.view.backgroundColor = [UIColor clearColor];
    [self addBlurBackground];
    [self buildInterface];
    if (_routeQuizz) {
        [self initQuizz];
    }
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
    [bgButton addTarget:self action:@selector(closePointVC) forControlEvents:UIControlEventTouchUpInside];
    
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
    _popupView = [[UIView alloc] initWithFrame:CGRectMake(padding, 64,
                                                                          [UIScreen mainScreen].bounds.size.width - padding*2,
                                                                          [UIScreen mainScreen].bounds.size.height - padding - 64)];
    _popupView.layer.cornerRadius = 8.0;
    _popupView.layer.masksToBounds = YES;
    _popupView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    _popupView.layer.borderWidth = 1.0;
    _popupView.backgroundColor = [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
    
    [self.view addSubview:_popupView];
    _popupView.translatesAutoresizingMaskIntoConstraints = NO;
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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                    _popupView.frame.size.width,
                                                                    titleHeight)];
    _titleLabel.text = _routePoint.title;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_popupView addSubview:_titleLabel];
    
    //Top Divide line
    padding = 8;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(padding, _titleLabel.frame.origin.y + _titleLabel.frame.size.height,
                                                               _popupView.frame.size.width - padding*2, 1)];
    topLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [_popupView addSubview:topLine];

    //Action button
    CGFloat buttonHeight = 50.0;
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(0, _popupView.bounds.size.height - buttonHeight, _popupView.bounds.size.width, buttonHeight);
    _actionButton.backgroundColor = [UIColor clearColor];
    [_actionButton setTitleColor:[UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0] forState:UIControlStateNormal];
    _actionButton.titleLabel.bounds = CGRectMake(0, 0, 140, 20);
    _actionButton.titleLabel.textColor = [UIColor colorWithHue:242/360.0 saturation:0.47 brightness:1.0 alpha:1.0];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    _actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_routePoint.route) {
        NSInteger index = [_routePoint.route.points indexOfObject:_routePoint];
        if ((index + 1) == _routePoint.route.points.count) {
            [_actionButton setTitle:@"Завершить маршрут" forState:UIControlStateNormal];
            [_actionButton addTarget:self action:@selector(closePointVC) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [_actionButton setTitle:@"Дальше" forState:UIControlStateNormal];
            if (_routePoint.quizz)
                [_actionButton addTarget:self action:@selector(startQuizz) forControlEvents:UIControlEventTouchUpInside];
            else
                [_actionButton addTarget:self action:@selector(closePointVC) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
            [_actionButton setTitle:@"Error" forState:UIControlStateNormal];
            [_actionButton addTarget:self action:@selector(closePointVC) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1, 0, _actionButton.frame.size.width - 2, 1)];
    line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [_actionButton addSubview:line];
    
    [_popupView addSubview:_actionButton];
    
    //Text block
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, topLine.frame.origin.y + 1,
                                                                        _popupView.frame.size.width - padding*2,
                                                                        _popupView.frame.size.height - buttonHeight - titleHeight)];
    _textView.text = _routePoint.text;
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    _textView.textAlignment = NSTextAlignmentJustified;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    _textView.showsVerticalScrollIndicator = NO;
    
    [_popupView addSubview:_textView];
}


- (void)initQuizz {
    NSLog(@"Quiz initialization");
    
    //Quizz Text View initialization
    CGFloat areaHeight = _actionButton.frame.origin.y - (_titleLabel.frame.origin.y + _titleLabel.frame.size.height);
    CGFloat padding = 8;

    _quizzTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, 40,
                                                                  _popupView.frame.size.width - 2*padding, areaHeight - _popupView.frame.size.width)];
    _quizzTextView.text = _routeQuizz.text;
    _quizzTextView.textColor = [UIColor whiteColor];
    _quizzTextView.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    _quizzTextView.textAlignment = NSTextAlignmentJustified;
    _quizzTextView.backgroundColor = [UIColor clearColor];
    _quizzTextView.editable = NO;
    _quizzTextView.showsVerticalScrollIndicator = NO;
        [_quizzTextView setHidden:YES];
    [_popupView addSubview:_quizzTextView];
    
    //Page View Controller initialization
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                            options:nil];
    _pageVC.dataSource = self;
    _pageVC.delegate = self;
    
    [_pageVC.view setFrame:CGRectMake(0, 40 + areaHeight - _popupView.frame.size.width,
                                      _popupView.frame.size.width, _popupView.frame.size.width)];
    _pageVC.view.backgroundColor = [UIColor clearColor];
    [_pageVC setViewControllers:@[[self childViewControllerAtIndex:0]]
                      direction:UIPageViewControllerNavigationDirectionForward
                       animated:NO
                     completion:nil];
    [_pageVC.view setHidden:YES];
    [_popupView addSubview:_pageVC.view];
    

    
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


- (void)startQuizz {
//    NSLog(@"_popupView subviews: \n%@\n______________", _popupView.subviews);
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_textView setHidden:YES];
                         [_pageVC.view setHidden:NO];
                         [_quizzTextView setHidden:NO];
                         [_actionButton setTitle:@"Выбрать" forState:UIControlStateNormal];
                     } completion:^(BOOL finished) {
                         [_actionButton removeTarget:self
                                              action:@selector(startQuizz)
                                    forControlEvents:UIControlEventTouchUpInside];
                         [_actionButton addTarget:self
                                           action:@selector(checkSelection)
                                 forControlEvents:UIControlEventTouchUpInside];
                     }];
}
- (void)checkSelection {
    if (currentPage+1 == _routeQuizz.correctIndex) {
        NSLog(@"Correct selection!");
        [_detailVC openNextRoutePoint];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"Wrong selection!");
    }
}

- (void)closePointVC {
    NSLog(@"Dismissing Point View Controller");
    [_detailVC openNextRoutePoint];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPageViewController methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return _routeQuizz.imageSet.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [viewController.title integerValue];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self childViewControllerAtIndex: index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [viewController.title integerValue];
    index++;
    if (index == _routeQuizz.imageSet.count) {
        return nil;
    }
    return [self childViewControllerAtIndex:index];
}
- (UIViewController *)childViewControllerAtIndex:(NSUInteger)index {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"%ld", (long)index];
//    NSInteger side = _pageVC.view.frame.size.width - 36;
    [vc.view setFrame:CGRectMake(8, 0, _pageVC.view.frame.size.width - 2*8, _pageVC.view.frame.size.width - 36)];
//    CGPoint center = _pageVC.view.center;
//    center.y = 0;
//    vc.view.center = center;
    vc.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame:vc.view.frame];
    [imgView setImage:[_routeQuizz.imageSet objectAtIndex:index]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    [vc.view addSubview:imgView];
    
    return vc;
}
+ (UIImage *)buttonImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        
        currentPage = [[_pageVC.viewControllers lastObject].title integerValue];
        NSLog(@"Current Page: %ld", currentPage);
    }
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
