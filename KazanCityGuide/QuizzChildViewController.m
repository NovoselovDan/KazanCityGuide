//
//  QuizzChildViewController.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 18.10.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "QuizzChildViewController.h"

@interface QuizzChildViewController ()
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;

@end

@implementation QuizzChildViewController

- (instancetype)initWithIndex:(NSInteger)index text:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        _index = index;
        _text  = text;
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
