//
//  ESettingBottomBar.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/22.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESettingBottomBar;
@protocol ESettingBottomBarDelegate  <NSObject>

- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar fontSizeChanged:(int)fontSize;//改变字号
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar callDrawerView:(UIButton *)button;//侧边栏
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar turnToNextChapter:(UIButton *)button;//下一章
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar turnToPreChapter:(UIButton *)button;//上一章
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar sliderToChapterPage:(NSInteger)chapterIndex;
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar themeButtonAction:(id)myself themeIndex:(NSInteger)theme;
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar callCommentView:(UIButton *)button;

@end
@interface ESettingBottomBar : UIView

@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UIButton *bigFont;
@property (nonatomic,weak) id<ESettingBottomBarDelegate>delegate;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;

- (void)changeSliderRatioNum:(float)percentNum;

- (void)showToolBar;

- (void)hideToolBar;

@end
