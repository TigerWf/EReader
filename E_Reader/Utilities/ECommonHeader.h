//
//  ECommonHeader.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#ifndef ECommonHeader_h
#define ECommonHeader_h


#define ESAVEPAGE @"ESAVEPAGE"
#define ESAVECHAPTER @"ESAVECHAPTER"
#define EFONT_SIZE @"EFONT_SIZE"
#define ETHEMEID @"ETHEMEID"
#define EpubBookName @"epubBookName"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define offSet_x 20
#define offSet_y 40

#define kReaderWidth (SCREEN_MIN_LENGTH - 2 * offSet_x)
#define kReaderHeight (SCREEN_MAX_LENGTH - offSet_y - 20)

#define kBottomBarH 150

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#warning todo -需自行替换
#define kChapterListUrl @"ListUrl"
#define kChapterInfoUrl @"ChapterInfoUrl"

#endif /* ECommonHeader_h */
