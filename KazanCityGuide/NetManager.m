//
//  NetManager.m
//  KazanCityGuide
//
//  Created by Daniil Novoselov on 09.09.16.
//  Copyright © 2016 Daniil Novoselov. All rights reserved.
//

#import "NetManager.h"

@interface NetManager()


@end

@implementation NetManager

+ (NetManager *)sharedClient {
    static NetManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetManager alloc] initWithManager];
    });
    return _sharedClient;
}
-(instancetype)initWithManager{
    self = [super init];
//    if (self) {
//        _restManager = [[SSRestManager alloc] init];
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]) {
//            [self TEMPgetTokenWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]
//                               andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] andCompletion:^(NSError *error) {
//                                   if (!error) {
//                                   }
//                               }];
//        }
//    }
    return self;
}
@end
