//
//  EDataSourceManager.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EDataSourceManager.h"
#import "EDataCenter.h"
#import "ECommonHeader.h"

@implementation EDataSourceManager

+ (EDataSourceManager *)shareInstance{
    
    static EDataSourceManager *dataSource;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        dataSource = [[EDataSourceManager alloc] init];
        
    });
    
    return dataSource;
}

- (EEveryChapter *)openChapter:(NSInteger)clickChapter{
    
    _currentChapterIndex = clickChapter;
    
    EEveryChapter *chapter = [[EEveryChapter alloc] init];
// **************此处为原先读本地的小说源******************
//    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
//    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    
    chapter.chapterContent = [self readChapterContentsWithChapterNo:_currentChapterIndex needDownLoad:YES];
    chapter.chapterNum = _currentChapterIndex;
    
    return chapter;
}

- (EEveryChapter *)openChapter{
    
    NSUInteger index = [EDataCenter e_getChapterBefore];
    
    _currentChapterIndex = index;
    
    EEveryChapter *chapter = [[EEveryChapter alloc] init];
// **************此处为原先读本地的小说源******************
//    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
//    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    
    chapter.chapterContent = [self readChapterContentsWithChapterNo:_currentChapterIndex needDownLoad:YES];
    chapter.chapterNum = _currentChapterIndex;
    
    return chapter;
}

- (NSUInteger)openPage{
    
    NSUInteger index = [EDataCenter e_getPageBefore];
    return index;
    
}


- (EEveryChapter *)nextChapter{
    
//    if (_currentChapterIndex >= _totalChapter) {
//        //[E_HUDView showMsg:@"没有更多内容了" inView:nil];
//        return nil;
//        
//    }else{
        _currentChapterIndex++;
        
        EEveryChapter *chapter = [EEveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex,YES);
        
        return chapter;
        
//    }
    
}

- (EEveryChapter *)preChapter{
    
    if (_currentChapterIndex <= 1) {
       // [E_HUDView showMsg:@"已经是第一页了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex --;
        
        EEveryChapter *chapter = [EEveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex ,YES);
        
        return chapter;
    }
}

- (void)resetTotalString{
    
    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    
    for (int i = 1; i <  INT_MAX; i ++) {
        
        if (readTextData(i,NO).length > 0) {
            
            NSUInteger location = _totalString.length;
            [_totalString appendString:readTextData(i,NO)];
            NSUInteger length = _totalString.length - location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject:NSStringFromRange(chapterRange)];
            
            
        }else{
            break;
        }
    }
    
}

- (NSInteger)getChapterBeginIndex:(NSInteger)page{
    
    NSInteger index = 0;
    for (int i = 1; i < page; i ++) {
        
        if (readTextData(i,NO).length > 0) {
            
            index += readTextData(i,NO).length;
            // NSLog(@"index == %ld",index);
            
        }else{
            break;
        }
    }
    return index;
}

- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord{
    //关键字为空 则返回空数组
    if (keyWord == nil || [keyWord isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    
    
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    
    //一次搜索20条
    for (int i = 0; i < 20; i++) {
        
        if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound) {
            
            NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
            NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
            // NSLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
            int temp = 0;
            for (int j = 0; j < _everyChapterRange.count; j ++) {
                if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location) {
                    temp ++;
                }else{
                    break;
                }
                
            }
            
            [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
            [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
            
            NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
            NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [searchResult addObject:completeString];
            
            
            
            [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
            
        }else{
            break;
        }
    }
    
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;
    
}

- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender{
    
    //获取1到x之间的整数
    if (sender == YES) {
        
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0) {
            location = temp;
        }
        
        return location;
        
    }else{
        
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length) {
            value = 0;
        }else{
            //do nothing
        }
        
        return value;
    }
}

static NSString *readTextData(NSUInteger index , bool downLoad){
 // **************此处为原先读本地的小说源******************   
//    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",index];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
//    NSString *content = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    NSString *content = [[EDataSourceManager shareInstance] readChapterContentsWithChapterNo:index needDownLoad:downLoad];
    return content;
}




////////////
- (void)downloadContentsWithChapterNo:(NSInteger)chapterNo{

    WS(weakSelf);
    NSString *contentsUrl = kChapterInfoUrl;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%zd",contentsUrl,chapterNo]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(!connectionError){
            
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            EEveryChapter *everyChapter = [EEveryChapter mj_objectWithKeyValues:jsonString];
            [weakSelf handleResultModel:everyChapter];
            [weakSelf prepareToReading:everyChapter];
            
        }else{
            
        }
        
    }];
}

- (NSString *)readChapterContentsWithChapterNo:(NSInteger)chapterNo needDownLoad:(BOOL)flag{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    
    NSString *newFielPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Chapter%zd.txt",chapterNo]];
    
    NSString *content = [NSString stringWithContentsOfFile:newFielPath encoding:NSUTF8StringEncoding error:nil];
    if (content.length > 0) {//如果有 就读取
        return content;
    }else{//没有就下载
        if (flag) {
            [self downloadContentsWithChapterNo:chapterNo];
        }
        
        return @"";
    }
    
}


- (void)handleResultModel:(EEveryChapter *)everyChapter{

    if (everyChapter.chapterContent.length > 0) {//存本地
        NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
        
        NSString *newFielPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Chapter%zd.txt",everyChapter.chapterNum]];
                                
        NSError *error = nil;
                                
        BOOL isSucceed = [everyChapter.chapterContent writeToFile:newFielPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"isSucceed = %d",isSucceed);
        
    }
}

- (void)prepareToReading:(EEveryChapter *)everyChapter{

    if (everyChapter.chapterNum == _currentChapterIndex) {
        if (_readingBlock) {
            _readingBlock(_currentChapterIndex);
        }
    }
}


////章节信息
- (void)downloadChapterInfo:(NSString *)bookId finish:(void(^)())downloadFinsih{
  
    WS(weakSelf);
    NSString *chapterInfoUrl = kChapterListUrl;
    NSURL *url = [NSURL URLWithString:chapterInfoUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(!connectionError){
            
             NSError *error;
             NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
             weakSelf.chapterInfoArray = [EEveryChapter mj_objectArrayWithKeyValuesArray:array];
             weakSelf.totalChapter = weakSelf.chapterInfoArray.count;
             downloadFinsih();
            
        }else{
            
        }
        
    }];
}

- (UIColor *)getThemeImage{

    NSInteger themeID = [EDataCenter e_getReadTheme];
    UIImage *_themeImage;
    if (themeID == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)themeID]];
    }
    
    if (_themeImage == nil) {
         return [UIColor whiteColor];
    }else{
         return [UIColor colorWithPatternImage:_themeImage];
    }
    
}

- (BOOL)isVipStatus{

    return self.isVip;

}

- (void)setVipStatus:(BOOL)isVip{

    self.isVip = isVip;
}

#pragma mark - Getter -
- (NSArray *)chapterInfoArray{

    if (!_chapterInfoArray) {
        _chapterInfoArray = [[NSArray alloc] init];
    }
    return _chapterInfoArray;
}

@end
