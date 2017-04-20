//
//  EDataSourceManager.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EEveryChapter.h"

typedef void(^prepareToReadingBlock) (NSInteger);

/**
 各类数据源
 */
@interface EDataSourceManager : NSObject
//当前章节数
@property (assign, nonatomic) NSInteger currentChapterIndex;

//总章节数
@property (assign, nonatomic) NSInteger totalChapter;

@property (strong, nonatomic) NSMutableString  *totalString;//全文

@property (strong, nonatomic) NSMutableArray   *everyChapterRange;//每章节的range

@property (copy  , nonatomic) prepareToReadingBlock readingBlock;

@property (copy  , nonatomic) NSArray *chapterInfoArray;

@property (assign, nonatomic) BOOL isVip;
/**
 *  单例
 *
 *  @return 实例
 */
+ (EDataSourceManager *)shareInstance;


/**
 *  通过传入id来获取章节信息
 *
 *  @return 章节类
 */
- (EEveryChapter *)openChapter;

/**
 *  章节跳转
 *
 *  @param clickChapter 跳转章节数
 *
 *  @return 该章节
 */
- (EEveryChapter *)openChapter:(NSInteger)clickChapter;

/**
 *  打开得页数
 *
 *  @return 返回页数
 */
- (NSUInteger)openPage;

/**
 *  获得下一章内容
 *
 *  @return 章节类
 */
- (EEveryChapter *)nextChapter;


/**
 *  获得上一章内容
 *
 *  @return 章节类
 */
- (EEveryChapter *)preChapter;

/**
 *  全文搜索
 *
 *  @param keyWord 要搜索的关键字
 *
 *  @return 搜索的关键字所在的位置
 */
- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord;


/**
 *  获得全文
 */
- (void)resetTotalString;


/**
 *  获得指定章节的第一个字在整篇文章中的位置
 *
 *  @param page 指定章节
 *
 *  @return 位置
 */
- (NSInteger)getChapterBeginIndex:(NSInteger)page;

/**
 *  下载小说
 *
 *  @param chapterNo 指定章节
 *
 *
 */
- (void)downloadContentsWithChapterNo:(NSInteger)chapterNo;

/**
 *  根据小说的id来下载章节信息 (收费与否 等等)
 *
 *  @param bookId 小说的id
 *
 */
- (void)downloadChapterInfo:(NSString *)bookId finish:(void(^)())downloadFinsih;

/**
 *  获得主题色
 *
 */
- (UIColor *)getThemeImage;

/**
 *  是不是vip
 *
 */
- (BOOL)isVipStatus;

/**
 *  设置vip
 *
 */
- (void)setVipStatus:(BOOL)isVip;

@end
