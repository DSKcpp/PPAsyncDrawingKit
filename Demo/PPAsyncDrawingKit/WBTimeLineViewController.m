//
//  WBTimeLineViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "WBTimeLineViewController.h"
#import "WBCardsModel.h"
#import "YYModel.h"
#import "WBCardCell.h"

@interface WBTimeLineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBCardModel *> *cards;
@end

@implementation WBTimeLineViewController

- (instancetype)init
{
    if (self = [super init]) {
        _cards = @[].mutableCopy;
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
    [self.view addSubview:_tableView];
    
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WBTimeLineJSON.json" ofType:@""];
        NSData *data = [NSData dataWithContentsOfFile:path];
        WBCardsModel *cards = [WBCardsModel yy_modelWithJSON:data];
        [_cards addObjectsFromArray:cards.cards];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"kWBCardCell";
    WBCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WBCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCard:_cards[indexPath.row]];
    return cell;
}

@end
