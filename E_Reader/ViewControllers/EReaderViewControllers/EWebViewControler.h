//
//  EWebViewControler.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

/**
 *  浏览器视图控制器
 */
@interface EWebViewControler : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>

@end
