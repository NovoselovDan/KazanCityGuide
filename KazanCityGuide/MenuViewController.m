//
//  MenuViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "MenuViewController.h"
#import "DetailViewController.h"
#import "RouteCollectionViewCell.h"

#import "PointViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
// Цвет панелей: H:240/360 S:0.13 B:24 /HEX:34343C
@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designSetup];
    
    Route *route = [_routes firstObject];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_routes];
    for (int i=0; i<20; i++) {
        [arr addObject:route];
    }
    _routes = arr;
    
    [self.collectionVIew registerClass:[RouteCollectionViewCell class] forCellWithReuseIdentifier:@"routeCell"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)segmentChanged:(id)sender {
    
}

- (IBAction)mapButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Design
- (void)designSetup {
    _collectionVIew.backgroundColor = [UIColor clearColor];
    
    //UIavigation Bar ustomizing
    _helpView.backgroundColor = [self backgroundColor];
    for (UIView *parentView in self.navigationController.navigationBar.subviews)
        for (UIView *childView in parentView.subviews)
            if ([childView isKindOfClass:[UIImageView class]])
                [childView removeFromSuperview];
    
    _segmentedControl.tintColor = [UIColor whiteColor];
    


    
    //Map button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 75, 20);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 17, 17)];
    [imgView setImage:[UIImage imageNamed:@"Map"]];
    [btn addSubview:imgView];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 55, 20)];
    lab.text = @"Карта";
    lab.textColor = [self tintColor];
    [btn addSubview:lab];
    [btn addTarget:self action:@selector(mapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barBtn;
    self.navigationItem.leftBarButtonItem.tintColor = [self tintColor];
    
    //Weather button
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 57, 20)];
    buttonView.backgroundColor = [UIColor clearColor];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 20, 17)];
    [imgView setImage:[UIImage imageNamed:@"Weather"]];
    [buttonView addSubview:imgView];
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 34, 20)];
    buttonLabel.text = @"23°";
    buttonLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:17.0];
    buttonLabel.textColor = [self tintColor];
    [buttonView addSubview:buttonLabel];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    //Title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    label.text = @"Казань";
    label.textColor = [self tintColor];
    label.font = [UIFont fontWithName:@".SFUIDisplay-Light" size:26.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    
}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}
- (UIColor *)backgroundColor {
    return [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
}
- (UIColor *)tintColor {
    return [UIColor colorWithHue:240/360.0 saturation:0.02 brightness:96 alpha:1.0];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _routes.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RouteCollectionViewCell *cell =(RouteCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"routeCell" forIndexPath:indexPath];
    [cell configureWithRoute:[_routes objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Route *route = [_routes objectAtIndex:indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *dvc = [sb instantiateViewControllerWithIdentifier:@"detailVC"];
    [dvc configureWithRoute:route];
    [self.navigationController pushViewController:dvc animated:YES];
    
//    PointViewController *pointVC = [[PointViewController alloc] init];
//    [pointVC configureWithRoutePoint:route.firstPoint];
//    pointVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self.navigationController presentViewController:pointVC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellSide = (int)(screenWidth - 2*20 - 15) / 2;
//    NSLog(@"cellSide: %f", cellSide);
    return CGSizeMake(cellSide, cellSide);
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"toDetail"];
        NSIndexPath *indexpath = [_collectionVIew.indexPathsForSelectedItems firstObject];
        [dvc configureWithRoute:[_routes objectAtIndex:indexpath.row]];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
*/

@end
