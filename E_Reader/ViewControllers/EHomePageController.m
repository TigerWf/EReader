//
//  EHomePageController.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EHomePageController.h"
#import "ERouter.h"
#import "EDataSourceManager.h"
#import "EHUDView.h"

@interface EHomePageController ()

@end

@implementation EHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = CGRectMake(50, 50, 200, 200);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"打开电子书" forState:0];
    [button addTarget:self action:@selector(doPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *vipButton = [UIButton buttonWithType:0];
    vipButton.frame = CGRectMake(50, 300, 100, 100);
    vipButton.backgroundColor = [UIColor redColor];
    [vipButton setTitle:@"获取vip资格" forState:0];
    [vipButton addTarget:self action:@selector(doVip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vipButton];
    
    UIButton *cancelVipButton = [UIButton buttonWithType:0];
    cancelVipButton.frame = CGRectMake(200, 300, 100, 100);
    cancelVipButton.backgroundColor = [UIColor redColor];
    [cancelVipButton setTitle:@"取消vip资格" forState:0];
    [cancelVipButton addTarget:self action:@selector(cancelVip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelVipButton];
    
}

- (void)doPush{

    [ERouter pushPage:EPageReader withDate:@{@"bookId":@"123"}];
    
}

- (void)doVip{
    
    [[EDataSourceManager shareInstance] setVipStatus:YES];
    [EHUDView showMsg:@"获取vip成功" inView:self.view];
}

- (void)cancelVip{
    
    [[EDataSourceManager shareInstance] setVipStatus:NO];
    [EHUDView showMsg:@"取消vip成功" inView:self.view];
}

@end
