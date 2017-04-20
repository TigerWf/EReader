//
//  EReaderSearchController.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EReaderSearchController.h"
#import "EDataSourceManager.h"
#import "ECommonHeader.h"
#import "ESearchResultCell.h"
#import "UIViewController+EData.h"

@interface EReaderSearchController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
   
    UITextField    *_searchTextField;
    BOOL           _isSearch;
    NSMutableArray *_dataSource;
    NSString       *_keyWord;
}

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong)  UITableView *searchResultView;


@end

@implementation EReaderSearchController

#pragma mark - CELL REUSE ID
static NSString * const kCellID = @"ECell";

- (void)dealloc{

    NSLog(@"release=====");

}

- (void)setE_InitData:(id)e_InitData{
    
    [super setE_InitData:e_InitData];
    self.delegate = [self.e_InitData valueForKey:@"delegate"];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [[EDataSourceManager shareInstance] getThemeImage];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];

    [self configNavigationBar];
    [self configResultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configNavigationBar{
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    navBarView.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [self.view addSubview:navBarView];
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(self.view.frame.size.width - 60, 20, 60, 44);
    [backBtn setTitle:@"取消" forState:0];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UIImageView *textFieldBg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, self.view.frame.size.width - 75, 36)];
    textFieldBg.layer.cornerRadius = 3;
    textFieldBg.backgroundColor = [UIColor whiteColor];
    [textFieldBg.layer setBorderWidth:1.0];
    textFieldBg.userInteractionEnabled = YES;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 230/255.0, 230/255.0, 230/255.0, 1 });
    [textFieldBg.layer setBorderColor:colorref];
    [self.view addSubview:textFieldBg];
    CGColorSpaceRelease(colorSpace);
    
    UIImageView *fangdajingBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 13, 13)];
    fangdajingBg.image = [UIImage imageNamed:@"magnifiter.png"];
    [textFieldBg addSubview:fangdajingBg];
    
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(45,28,textFieldBg.frame.size.width-30,32)];
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @"输入一个关键词";
    [self.view addSubview:_searchTextField];
  
}

- (void)configResultView{

    [self.view addSubview:self.searchResultView];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:_searchResultView]){
        
        CGFloat offSetY = scrollView.contentOffset.y;
        
       
        if (offSetY + 80 > scrollView.contentSize.height - SCREEN_HEIGHT) {
            if (!_isLoading) {
                [self loadMoreData];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isSearch == NO) {
        return 0;
    }else{
        return [[_dataSource objectAtIndex:0] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ESearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    [cell configData:_dataSource withSearchString:_searchTextField.text position:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchController:turnToClickSearchResult:withRange:andKeyWord:)]) {
        [self.delegate searchController:self turnToClickSearchResult:[[_dataSource objectAtIndex:1] objectAtIndex:indexPath.row] withRange:NSRangeFromString([[_dataSource objectAtIndex:2] objectAtIndex:indexPath.row])  andKeyWord:_keyWord];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [[EDataSourceManager shareInstance] resetTotalString];
    [_dataSource removeAllObjects];
    NSMutableArray *tempArray = [[EDataSourceManager shareInstance] searchWithKeyWords:textField.text];
    _keyWord = textField.text;
    [_dataSource addObject:[tempArray objectAtIndex:0]];
    [_dataSource addObject:[tempArray objectAtIndex:1]];
    [_dataSource addObject:[tempArray objectAtIndex:2]];
    
    [_searchTextField resignFirstResponder];
    _isSearch = YES;
    _searchResultView.hidden = NO;
    [_searchResultView reloadData];
    return YES;
    
}

- (void)loadMoreData{

    _isLoading = YES;
    
    NSMutableArray *tempArray = [[EDataSourceManager shareInstance] searchWithKeyWords:_searchTextField.text];
    
    [[_dataSource objectAtIndex:0] addObjectsFromArray:[tempArray objectAtIndex:0]];
    [[_dataSource objectAtIndex:1] addObjectsFromArray:[tempArray objectAtIndex:1]];
    [[_dataSource objectAtIndex:2] addObjectsFromArray:[tempArray objectAtIndex:2]];
    [_searchResultView reloadData];
    
    _isLoading = NO;

}

- (void)backToFront{

    [self dismissViewControllerAnimated:YES completion:NULL];

}

#pragma mark - Getter -
- (UITableView *)searchResultView{

    if (!_searchResultView) {
        _searchResultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
        _searchResultView.backgroundColor = [UIColor clearColor];
        _searchResultView.hidden = YES;
        [_searchResultView registerClass:[ESearchResultCell class] forCellReuseIdentifier:kCellID];

    }
    
    return _searchResultView;

}


@end
