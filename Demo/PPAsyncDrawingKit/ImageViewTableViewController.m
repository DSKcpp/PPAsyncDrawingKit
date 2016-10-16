//
//  ImageViewTableViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ImageViewTableViewController.h"
#import "PPRoundedImageView.h"

@interface AvatarImageCell : UITableViewCell @end

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

@interface ImageViewTableViewController ()

@end

@implementation ImageViewTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[AvatarImageCell class] forCellReuseIdentifier:@"kAvatarImageCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"kAvatarImageCell" forIndexPath:indexPath];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

@end
