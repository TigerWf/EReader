//
//  EWebViewControler.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EWebViewControler.h"
#import "UIViewController+EData.h"
#import "ECommonHeader.h"

@interface EWebViewControler (){
    
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString *_selectString;
    UILabel *_titleLabel;
    
}

@property (nonatomic, copy) NSString *webUrlString;

@end

@implementation EWebViewControler


- (void)setE_InitData:(id)e_InitData{
    
    [super setE_InitData:e_InitData];
    self.webUrlString = [self.e_InitData valueForKey:@"webUrlString"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavBar];
    
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    
    CGRect barFrame = CGRectMake(0, 64, self.view.frame.size.width ,progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_progressView];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrlString]];
    [_webView loadRequest:req];
}

#pragma mark - View -
- (void)configNavBar{

    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    navBarView.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [self.view addSubview:navBarView];
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = 1;
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(100, 20, MIN(SCREEN_WIDTH, SCREEN_HEIGHT) - 200, 44);
    [self.view addSubview:_titleLabel];

}

#pragma mark - User Action -
- (void)backToFront{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - NJKWebViewProgressDelegate -
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    
    [_progressView setProgress:progress animated:YES];
    
}

#pragma mark - UIWebViewDelegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    NSLog(@"error == %@",error.description);
}

@end
