//
//  EPageManager.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/22.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EEveryChapter.h"
#import "EReaderController.h"
#import "EPagingModule.h"

@class EPageManager;
@protocol EPageManagerDelegate <NSObject>

- (void)ePageManager:(EPageManager *)ePageManager hideTheSettingBar:(UIView *)settingBar;

@end

/**
 页面管理
 */
@interface EPageManager : NSObject<EReaderControllerDelegate>

@property (assign, nonatomic) NSInteger fontSize;
@property (strong, nonatomic) UIImage *themeImage;//主题

@property (assign, nonatomic) BOOL isNextChapter;
@property (assign, nonatomic) BOOL isNextPage;

@property (copy  , nonatomic) NSString *chapterContent;
@property (copy  , nonatomic) NSString *chapterTitle;

@property (assign, nonatomic) NSInteger lastPage;

@property (assign, nonatomic) NSInteger readPage;

@property (strong, nonatomic) EPagingModule *paginater;

@property (copy  , nonatomic) NSString *searchWord;

@property (weak  , nonatomic) id<EPageManagerDelegate>delegate;


+ (EPageManager *)shareInstance;

- (void)initAndOpenReader;

- (void)parseChapter:(EEveryChapter *)chapter;

- (void)resetStatusWhenTurnChapterFailed;//翻页未完成

- (EReaderController *)turnToNextPage:(UIViewController *)currentController;//下一页

- (EReaderController *)turnToPrePage:(UIViewController *)currentController;//上一页

- (EReaderController *)readerControllerWithPage:(NSInteger)page;

- (void)skipToChapter:(NSInteger)chapterIndex;//跳章节

- (NSInteger)fontSizeChanged:(int)fontSize withController:(EReaderController *)viewController;//字号变化

- (float)sliderPercentWhenChangeFontSize;//下面滑动条

- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset;

- (NSRange)getMarkRange;//获得书签文字范围

- (NSString *)getMarkContents;//获得书签文字内容

- (void)stopReading;//停止阅读


@end
