//
//  ViewController.m
//  ClassifyTableViewSample
//
//  Created by 周凯丽 on 2017/8/22.
//  Copyright © 2017年 t. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    BOOL _isUp;//方向是否向上
    CGFloat _rightOffsetY;//右边table的offset
}
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (strong, nonatomic) NSMutableArray *leftArray;//


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rightOffsetY = 0;
    _isUp = NO;
    [self.leftTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"leftTableView"];
    [self.rightTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"rightTableView"];
    self.leftTableView.tableFooterView = [UIView new];
    self.rightTableView.tableFooterView = [UIView new];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
- (NSMutableArray *)leftArray
{
    if (!_leftArray) {
        _leftArray = [NSMutableArray arrayWithObjects:@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123", nil];
    }
    return _leftArray;
}
- (void)scrollSection:(NSInteger)section
{
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionTop];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.rightTableView) {
        if (scrollView.contentOffset.y > _rightOffsetY) {
            _isUp = YES;
        }else{
            _isUp = NO;
        }
        _rightOffsetY = scrollView.contentOffset.y;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.rightTableView) {
        return self.leftArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.leftArray.count;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableStr = tableView == self.leftTableView ?@"leftTableView" :@"rightTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableStr forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (tableView == self.leftTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        
        CGRect headerRect = [self.rightTableView rectForSection:indexPath.row];
        CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _rightTableView.contentInset.top);
        [self.rightTableView setContentOffset:topOfHeader animated:YES];

        //下面的方法与上面的三个方法效果一样
//        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]
//                              atScrollPosition:UITableViewScrollPositionTop
//                                      animated:YES];

        
        [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.rightTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        view.backgroundColor = [UIColor yellowColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [NSString stringWithFormat:@"%ld",section + 1];
        [view addSubview:label];
        
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.rightTableView) {
        return 30;
    }
    return 0;

}
//将要显示区头
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView == self.rightTableView && !_isUp && (_rightTableView.dragging || _rightTableView.decelerating)) {
        [self scrollSection:section];
    }
}
//将要结束显示区头
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView == self.rightTableView && _isUp && (_rightTableView.dragging || _rightTableView.decelerating)) {
        [self scrollSection:section+1];
  
    }
}
@end
