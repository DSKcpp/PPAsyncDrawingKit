//
//  WBTimelineViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineViewController.h"
#import "WBCardsModel.h"
#import "YYModel.h"
#import "WBTimelineTableViewCell.h"
#import "WBTimelineContentView.h"

@interface WBTimelineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBTimelineItem *> *timelineItems;
@end

@implementation WBTimelineViewController

- (instancetype)init
{
    if (self = [super init]) {
        _timelineItems = @[].mutableCopy;
        _tableView = [[UITableView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WBTimeLineJSON.json" ofType:@""];
        NSData *data = [NSData dataWithContentsOfFile:path];
        WBCardsModel *cards = [WBCardsModel yy_modelWithJSON:data];
        [cards.cards enumerateObjectsUsingBlock:^(WBCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.mblog) {
                [_timelineItems addObject:obj.mblog];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timelineItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"kWBTimelineTableViewCell";
    WBTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WBTimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WBTimelineItem *item = _timelineItems[indexPath.row];
    [cell setTimelineItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WBTimelineContentView heightOfTimelineItem:_timelineItems[indexPath.row] withContentWidth:320];
    
}
@end
