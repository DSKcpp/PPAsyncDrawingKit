//
//  ViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ViewController.h"
#import "PPRoundedImageView.h"

@interface AvatarImageCell : UITableViewCell
@end

@implementation AvatarImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (NSInteger i = 0; i < 8; i++) {
//            UIImageView *avatarImageView = [[UIImageView alloc] init];
//            avatarImageView.frame = CGRectMake(i * 45, 5, 40, 40);
//            avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
//            avatarImageView.clipsToBounds = YES;
//            avatarImageView.layer.cornerRadius = 20.0f;
//            avatarImageView.image = [UIImage imageNamed:@"avatar"];
//            [self.contentView addSubview:avatarImageView];
            PPRoundedImageView *avatarImageView = [[PPRoundedImageView alloc] initWithCornerRadius:20.0f];
            avatarImageView.frame = CGRectMake(i * 45, 5, 40, 40);
            avatarImageView.image = [UIImage imageNamed:@"avatar"];
            [self.contentView addSubview:avatarImageView];
        }
    }
    return self;
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[AvatarImageCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.prefetchDataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    
}

- (void)tapImageView:(PPRoundedImageView *)imageView
{
    NSLog(@"%@", imageView);
}

@end

