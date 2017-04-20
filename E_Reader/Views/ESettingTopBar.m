//
//  ESettingTopBar.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/22.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ESettingTopBar.h"

@implementation ESettingTopBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        [self configUI];
    }
    return self;
    
}


- (void)configUI{
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UIButton *multifunctionBtn = [UIButton buttonWithType:0];
    multifunctionBtn.frame = CGRectMake(self.frame.size.width - 10 - 60, 20, 60, 44);
    [multifunctionBtn setImage:[UIImage imageNamed:@"reader_more.png"] forState:0];
    [multifunctionBtn setTitleColor:[UIColor whiteColor] forState:0];
    [multifunctionBtn addTarget:self action:@selector(multifunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:multifunctionBtn];
    
    
}


- (void)backToFront{
    
    if (_delegate && [_delegate respondsToSelector:@selector(settingTopBar:actionGoBack:)]) {
        [_delegate settingTopBar:self actionGoBack:nil];
    }
}

- (void)multifunction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(settingTopBar:actionShowMultifunction:)]) {
        [_delegate settingTopBar:self actionShowMultifunction:nil];
    }
    
}


- (void)showToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        
    }];
    
}

@end
