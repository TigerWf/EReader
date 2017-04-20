//
//  EEveryChapter.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
/**
 *  每章的内容与标题
 */
@interface EEveryChapter : NSObject

@property (nonatomic, copy)  NSString *chapterId;//章节id
@property (nonatomic, copy)  NSString *chapterContent;//章节内容
@property (nonatomic, copy)  NSString *chapterTitle;//章节标题
@property (nonatomic, assign) NSInteger chapterNum;//章节
@property (nonatomic, assign) NSInteger chapterIsFree;//是否免费  2收费 1免费

@end
