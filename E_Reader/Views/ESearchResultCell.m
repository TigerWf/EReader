//
//  ESearchResultCell.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ESearchResultCell.h"
#import "ECommonHeader.h"

@implementation ESearchResultCell{

   UILabel *_chapterLbl;
    
   UILabel *_contentLbl;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor grayColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, SCREEN_WIDTH - 40, 24)];
        _contentLbl.textColor = [UIColor blackColor];
        _contentLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _contentLbl.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_contentLbl];
        
    }
    return self;
}


#pragma mark - Public methods -
- (void)configData:(NSMutableArray *)data withSearchString:(NSString *)searchString position:(NSIndexPath *)indexPath{
   
    _chapterLbl.text = [NSString stringWithFormat:@"第%@章",[[data objectAtIndex:1] objectAtIndex:indexPath.row]];
    
    //寻找并变色
    NSMutableString *attString = [NSMutableString stringWithString:[[data objectAtIndex:0] objectAtIndex:indexPath.row]];
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < searchString.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    for (int i = 0; i < INT_MAX; i++) {
        
        if ([attString rangeOfString:searchString options:1].location != NSNotFound){
            NSInteger newLo = [attString rangeOfString:searchString  options:1].location;
            NSInteger newLen = [attString rangeOfString:searchString  options:1].length;
            NSRange newRange = NSMakeRange(newLo, newLen);
            [rangeArray addObject:NSStringFromRange(newRange)];
            [attString replaceCharactersInRange:newRange withString:blankWord];
            
        }else{
            
            break;
        }
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[data objectAtIndex:0] objectAtIndex:indexPath.row]];
    for (int i = 0; i < rangeArray.count; i ++) {
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSRangeFromString([rangeArray objectAtIndex:i])];
    }
    _contentLbl.attributedText = str;

}





@end
