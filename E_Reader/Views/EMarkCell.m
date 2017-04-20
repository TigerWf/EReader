//
//  EMarkCell.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EMarkCell.h"
#import "ECommonHeader.h"

@implementation EMarkCell{

   UILabel *_chapterLbl;
   UILabel *_timeLbl;
   UILabel *_contentLbl;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor redColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        
        
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3 / 4 - 125, 5, 110, 20)];
        _timeLbl.textColor = [UIColor redColor];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 28, SCREEN_WIDTH * 3 / 4 - 50, 60)];
        _contentLbl.numberOfLines = 3;
        _contentLbl.font = [UIFont systemFontOfSize:16];
        _contentLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLbl];
    }
    return self;
}

#pragma mark - Setter -
- (void)setModel:(EMarkModel *)model{

    _chapterLbl.text = [NSString stringWithFormat:@"第%@章",model.markChapter];
    _timeLbl.text    = model.markTime;
    _contentLbl.text = model.markContent;
}

@end
