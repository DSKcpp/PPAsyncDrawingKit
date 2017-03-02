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
#import "WBWebViewController.h"
#import "PPImageCache.h"
#import "WBTimelineAttributedTextParser.h"
#import "NSString+Encode.h"
#import "PPTableView.h"
#import "WBHelper.h"
#import "UIColor+HexString.h"

@interface WBTimelineViewController () <UITableViewDelegate, UITableViewDataSource, WBTimelineTableViewCellDelegate>
@property (nonatomic, strong) PPTableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBTimelineItem *> *timelineItems;
@end

@implementation WBTimelineViewController

- (instancetype)init
{
    if (self = [super init]) {
        _timelineItems = @[].mutableCopy;
        _tableView = [[PPTableView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertTimelineItem)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    [self.view addSubview:_tableView];
    
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.text = @"Loading...";
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor grayColor];
    [loadingLabel sizeToFit];
    loadingLabel.center = self.view.center;
    [self.view addSubview:loadingLabel];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WBTimelineJSON" ofType:@"zip"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        data = [WBHelper uncompressZippedData:data];
        WBCardsModel *cards = [WBCardsModel yy_modelWithJSON:data];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        CGFloat width = _tableView.bounds.size.width;

        [cards.cards enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(WBCardModel * _Nonnull card, NSUInteger idx, BOOL * _Nonnull stop) {
            WBTimelineItem *timelineItem;
            if (card.mblog) {
                timelineItem = card.mblog;
            } else if (card.card_group) {
                timelineItem = card.card_group.firstObject.mblog;
            }
            
            if (timelineItem) {
                [WBTimelineContentView heightOfTimelineItem:card.mblog withContentWidth:width];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                [_timelineItems addObject:timelineItem];
                dispatch_semaphore_signal(semaphore);
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = [NSString stringWithFormat:@"%zd 条微博", _timelineItems.count];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.tableView reloadData];
            loadingLabel.hidden = YES;
        });
    });
}

- (void)insertTimelineItem
{
    WBTimelineItem *obj = [_timelineItems objectAtIndex:arc4random() % _timelineItems.count];
    [_timelineItems insertObject:obj atIndex:0];
    [_tableView reloadData];
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
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBTimelineItem *timelineItem = _timelineItems[indexPath.row];
    return [WBTimelineContentView heightOfTimelineItem:timelineItem withContentWidth:tableView.bounds.size.width];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didPressHighlightRange:(PPTextHighlightRange *)highlightRange
{
    NSDictionary *userInfo = highlightRange.userInfo;
    if (!userInfo) {
        return;
    }
    NSString *atName = userInfo[WBTimelineHighlightRangeModeMention];
    if (atName) {
        atName = [[atName substringFromIndex:1] stringByURLEncode];
        NSString *URL = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@", atName];
        WBWebViewController *webViewController = [[WBWebViewController alloc] initWithURL:[NSURL URLWithString:URL]];
        [self.navigationController pushViewController:webViewController animated:YES];
        return;
    }
    
    NSString *topicName = userInfo[WBTimelineHighlightRangeModeTopic];
    if (topicName) {
        topicName = [topicName substringFromIndex:1];
        topicName = [topicName substringToIndex:topicName.length - 1];
        topicName = [topicName stringByURLEncode];
        NSString *URL = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@", topicName];
        WBWebViewController *webViewController = [[WBWebViewController alloc] initWithURL:[NSURL URLWithString:URL]];
        [self.navigationController pushViewController:webViewController animated:YES];
        return;
    }
    
    NSString *url = userInfo[WBTimelineHighlightRangeModeLink];
    if (url) {
        WBWebViewController *webViewController = [[WBWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self.navigationController pushViewController:webViewController animated:YES];
        return;
    }
}

- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didSelectedStatus:(WBTimelineItem *)timeline
{
    NSString *URL = [NSString stringWithFormat:@"http://m.weibo.cn/status/%@", timeline.mblogid];
    WBWebViewController *webViewController = [[WBWebViewController alloc] initWithURL:[NSURL URLWithString:URL]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didSelectedAvatarView:(WBUser *)user
{
    NSString *URL = [NSString stringWithFormat:@"http://m.weibo.cn/u/%@", user.idstr];
    WBWebViewController *webViewController = [[WBWebViewController alloc] initWithURL:[NSURL URLWithString:URL]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)tableViewCell:(WBTimelineTableViewCell *)tableViewCell didSelectedNameLabel:(WBUser *)user
{
    NSString *URL = [NSString stringWithFormat:@"http://m.weibo.cn/u/%@", user.idstr];
    WBWebViewController *webViewController = [[WBWebViewController alloc] initWithURL:[NSURL URLWithString:URL]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
