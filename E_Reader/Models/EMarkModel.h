//
//  EMarkModel.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface EMarkModel : NSObject

@property (nonatomic,strong) NSString  *markChapter;
@property (nonatomic,strong) NSString  *markRange;
@property (nonatomic,strong) NSString  *markContent;
@property (nonatomic,strong) NSString  *markTime;

@end
