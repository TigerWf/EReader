//
//  EDataCenter.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 本地化相关类
 */
@interface EDataCenter : NSObject

/**
 *  获得之前看的页码
 *
 *  @return 页码数
 */
+ (NSInteger)e_getPageBefore;


/**
 *  获得之前看的章节
 *
 *  @return 章节数
 */
+ (NSInteger)e_getChapterBefore;


/**
 *  保存章节
 *
 *  @param currentChapter 现章节
 */
+ (void)saveCurrentChapter:(NSInteger)currentChapter;


/**
 *  保存页码
 *
 *  @param currentPage 现页码
 */
+ (void)saveCurrentPage:(NSInteger)currentPage;


/**
 *  获得字号
 *
 *  @return 字号大小
 */
+ (NSInteger)e_getFontSize;


/**
 *  存储字号
 *
 *  @param fontSize 存储的字号大小
 */
+ (void)saveFontSize:(NSUInteger)fontSize;



/**
 *  获得主题背景
 *
 *  @return 主题背景id
 */
+ (NSInteger)e_getReadTheme;


/**
 *  保存主题ID
 *
 *  @param currentThemeID 主题ID
 */
+ (void)saveCurrentThemeID:(NSInteger)currentThemeID;


/**
 *  获得书签数组
 *
 *  @return 数组
 */

+ (NSMutableArray *)e_getMark;

/**
 *  保存书签
 *
 *  @param currentChapter 当前章节
 *  @param chapterRange   当前页起始的一段文字的range
 */
+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent;

/**
 *  检查当前页是否加了书签
 *
 *  @param currentRange 当前range
 *  @param currentChapter
 *  @return 是否加了书签
 */
+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter;

@end
