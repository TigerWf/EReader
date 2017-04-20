//
//  ERouter.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EPage) {
    
    EPageReader,
    EPageSearch,
    EPageWebSafari,//跳safari
    EPageWebInsider//内部web
  
};

@interface ERouter : NSObject

+ (instancetype)sharedInstance;

+ (void)pushPage:(EPage)page;
+ (void)pushPage:(EPage)page withDate:(id)data;

+ (void)presentPage:(EPage)page;
+ (void)presentPage:(EPage)page withDate:(id)data;


@end
