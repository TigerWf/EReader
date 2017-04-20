//
//  EMainNavigationController.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EMainNavigationController.h"
#import "EHomePageController.h"

@interface EMainNavigationController ()

@end

@implementation EMainNavigationController

+ (instancetype)shareNavigationController{
    
    static EMainNavigationController *_shareNavigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareNavigationController) {
            _shareNavigationController = [[EMainNavigationController alloc] init];
        }
    });
    
    return _shareNavigationController;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    EHomePageController *homePageController = [[EHomePageController alloc] init];
    [self setViewControllers:@[homePageController] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
