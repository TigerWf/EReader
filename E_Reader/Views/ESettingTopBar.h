//
//  ESettingTopBar.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/22.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESettingTopBar;
@protocol ESettingTopBarDelegate <NSObject>

- (void)settingTopBar:(ESettingTopBar *)settingTopBar actionGoBack:(UIButton *)button;
- (void)settingTopBar:(ESettingTopBar *)settingTopBar actionShowMultifunction:(UIButton *)button;


@end

@interface ESettingTopBar : UIView

@property (nonatomic, weak) id<ESettingTopBarDelegate>delegate;

- (void)showToolBar;

- (void)hideToolBar;

@end
