//
//  WBTimelineViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimelineViewController.h"
#import "WBTimelineItem.h"
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WBTimeLineJSON.json" ofType:@""];
        WBCardsModel *cards = [WBCardsModel yy_modelWithJSON:[NSData dataWithContentsOfFile:path]];
        CGFloat width = _tableView.bounds.size.width;
        [cards.cards enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(WBCardModel * _Nonnull card, NSUInteger idx, BOOL * _Nonnull stop) {
            if (card.mblog) {
                [WBTimelineContentView heightOfTimelineItem:card.mblog withContentWidth:width];
                [_timelineItems addObject:card.mblog];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        });
    });
}

- (void)reloadData
{
    WBTimelineItem *obj = [_timelineItems objectAtIndex:arc4random() % _timelineItems.count];
    [_timelineItems insertObject:obj atIndex:0];
    [_tableView reloadData];
//    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timelineItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"kWBTimelineTableViewCell";
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
    WBTimelineItem *timelineItem = _timelineItems[indexPath.row];
    return [WBTimelineContentView heightOfTimelineItem:timelineItem withContentWidth:tableView.bounds.size.width];
}

@end
