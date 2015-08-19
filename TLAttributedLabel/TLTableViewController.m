//
//  TLTableViewController.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/17.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLTableViewController.h"
#import "TLTableViewCell.h"
#import "TLAttributedLabel.h"
#import "TLModel.h"

static NSString *const identifier = @"UITableViewCell";

@interface TLTableViewController()

@property (nonatomic, strong) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableDictionary *offscreenCell;

@end

@implementation TLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"table";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[TLTableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.tableHeaderView = [UIView new];
    
    NSString *str = @"@京东 2014年4月，[/haqian.gif]有网友曝光了一组奶茶妹妹章泽天ss与京东老总刘强东的约会照。 4月7日，刘强东微博Https://www.baidu.com/s?cl=3&tn=baidutop10&fr=top1000&wd=%E5%AD%A6%E7%94%9F%E5%90%88%E5%94%B1%E8%87%B4%E8%88%9E%E5%8F%B0%E5%9D%8D%E5%A1%8C&rsv_idx=2发声，称“我们每个人都有选择和决定自己生活的权利。小天是我见过最单纯善良的人，很遗憾自己没能保护好她。感谢大家关心，只求以后可以正常牵手而行。@奶茶妹妹 [/haha] #开心时刻#”[/haha.gif] ";
    
    self.offscreenCell = [NSMutableDictionary dictionary];
    self.dataList = [NSMutableArray arrayWithCapacity:20];
    for (NSUInteger idx = 0; idx < 25; idx ++) {
        NSUInteger length = rand() % str.length;
        NSString *title = [str substringToIndex:length];
        TLModel *model = [[TLModel alloc] init];
        model.title = title;
//        model.numberOfLines = numberOfLines;
        [_dataList addObject:model];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setModel:_dataList[indexPath.row]];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLTableViewCell *cell = [self.offscreenCell objectForKey:identifier];
    if(!cell){
        cell = [[TLTableViewCell alloc] init];
        [self.offscreenCell setObject:cell forKey:identifier];
    }
    
    TLModel *model = _dataList[indexPath.row];
    [cell.label setText:model.title];
    cell.label.imageSize = CGSizeMake(20, 20);
    cell.label.numberOfLines = model.numberOfLines;
    
    CGSize size = [cell.label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kMargin, MAXFLOAT)];
    
    return size.height + 2*kMargin;
}

@end
