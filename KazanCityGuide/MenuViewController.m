//
//  MenuViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 10.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "MenuViewController.h"
#import "RouteCollectionViewCell.h"

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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentChanged:(id)sender {
    //!!!
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - Design
- (void)designSetup {
    _helpView.backgroundColor = [self backgroundColor];
    
    for (UIView *parentView in self.navigationController.navigationBar.subviews)
        for (UIView *childView in parentView.subviews)
            if ([childView isKindOfClass:[UIImageView class]])
                [childView removeFromSuperview];
    
    _segmentedControl.tintColor = [UIColor whiteColor];
    
    _collectionVIew.backgroundColor = [UIColor clearColor];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithHue:240/360.0 saturation:0.13 brightness:0.24 alpha:1.0];
}

#pragma mark -
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _routes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RouteCollectionViewCell *cell =(RouteCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"routeCell" forIndexPath:indexPath];
    [cell configureWithRoute:[_routes objectAtIndex:indexPath.row]];
    return cell;
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
