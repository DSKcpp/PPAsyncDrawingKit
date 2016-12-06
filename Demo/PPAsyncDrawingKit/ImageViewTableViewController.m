//
//  ImageViewTableViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ImageViewTableViewController.h"
#import "PPImageView.h"

@interface AvatarImageCell : UITableViewCell @end

@implementation AvatarImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (NSInteger i = 0; i < 7; i++) {
            PPImageView *roundedImageView = [[PPImageView alloc] initWithFrame:CGRectMake(i * 45.0f, 5.0f, 40.0f, 40.0f)];
            roundedImageView.cornerRadius = 20.0f;
            roundedImageView.roundedCorners = UIRectCornerAllCorners;
            roundedImageView.borderWidth = 1.0f;
            roundedImageView.borderColor = [UIColor blackColor];
            roundedImageView.contentMode = UIViewContentModeScaleAspectFill;
            roundedImageView.userInteractionEnabled = YES;
            roundedImageView.image = [UIImage imageNamed:@"avatar"];
            [roundedImageView addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:roundedImageView];
        }
    }
    return self;
}

- (void)tapImageView:(PPImageView *)imageView
{
    NSLog(@"%@", imageView.image);
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
    return [tableView dequeueReusableCellWithIdentifier:@"kAvatarImageCell" forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

@end
