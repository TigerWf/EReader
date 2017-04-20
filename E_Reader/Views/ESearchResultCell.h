//
//  ESearchResultCell.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESearchResultCell : UITableViewCell

- (void)configData:(NSMutableArray *)data withSearchString:(NSString *)searchString position:(NSIndexPath *)indexPath;


@end
