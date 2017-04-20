//
//  EDataCenter.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EDataCenter.h"
#import "ECommonHeader.h"
#import "EMarkModel.h"

@implementation EDataCenter

+ (NSInteger)e_getPageBefore{
    
    NSString *pageID = [[NSUserDefaults standardUserDefaults] objectForKey:ESAVEPAGE];
    
    if (pageID == nil) {
        
        return 0;
        
    }else{
        
        return [pageID integerValue];
        
    }
    
}

+ (NSInteger)e_getChapterBefore{


    NSString *chapterID = [[NSUserDefaults standardUserDefaults] objectForKey:ESAVECHAPTER];
    
    if (chapterID == nil) {
        
        return 1;
        
    }else{
        
        return [chapterID integerValue];
        
    }
}

+ (void)saveCurrentPage:(NSInteger)currentPage{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentPage) forKey:ESAVEPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (void)saveCurrentChapter:(NSInteger)currentChapter{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentChapter) forKey:ESAVECHAPTER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSInteger)e_getFontSize{
    
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:EFONT_SIZE];
    if (fontSize == 0) {
        fontSize = 20;
    }
    return fontSize;
}

+ (void)saveFontSize:(NSUInteger)fontSize{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:EFONT_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)e_getReadTheme{
    
    NSString *themeID = [[NSUserDefaults standardUserDefaults] objectForKey:ETHEMEID];
    
    if (themeID == nil){
        return 1;
        
    }else{
        return [themeID integerValue];
    }
}

+ (void)saveCurrentThemeID:(NSInteger)currentThemeID{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentThemeID) forKey:ETHEMEID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSMutableArray *)e_getMark{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EpubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (oldSaveArray.count == 0) {
        return nil;
    }else{
        return oldSaveArray;
        
    }
    
}

+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent{

    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    EMarkModel *eMark = [[EMarkModel alloc] init];
    eMark.markRange   = NSStringFromRange(chapterRange);
    eMark.markChapter = [NSString stringWithFormat:@"%zi",currentChapter];
    eMark.markContent = [chapterContent substringWithRange:chapterRange];
    eMark.markTime    = locationString;
    
    //  NSLog(@"chapterRange == %@",NSStringFromRange(chapterRange));
    
    if (![self checkIfHasBookmark:chapterRange withChapter:currentChapter]) {//没加书签
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EpubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSaveArray.count == 0) {
            
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newSaveArray] forKey:EpubBookName];
            
        }else{
            
            [oldSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:EpubBookName];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{//有书签
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EpubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0 ; i < oldSaveArray.count; i ++) {
            
            EMarkModel *e = (EMarkModel *)[oldSaveArray objectAtIndex:i];
            
            if (((NSRangeFromString(e.markRange).location >= chapterRange.location) && (NSRangeFromString(e.markRange).location < chapterRange.location + chapterRange.length)) && ([e.markChapter isEqualToString:[NSString stringWithFormat:@"%zi",currentChapter]])) {
                
                [oldSaveArray removeObject:e];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:EpubBookName];
                
            }
        }
    }
}


+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EpubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    int k = 0;
    for (int i = 0; i < oldSaveArray.count; i ++) {
        EMarkModel *e = (EMarkModel *)[oldSaveArray objectAtIndex:i];
        
        if ((NSRangeFromString(e.markRange).location >= currentRange.location) && (NSRangeFromString(e.markRange).location < currentRange.location + currentRange.length) && [e.markChapter isEqualToString:[NSString stringWithFormat:@"%zi",currentChapter]]) {
            k++;
        }else{
            // k++;
        }
    }
    if (k >= 1) {
        return YES;
    }else{
        return NO;
    }
}


@end
