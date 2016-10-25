//
//  ImageViewTableViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "ImageViewTableViewController.h"
#import "PPRoundedImageView.h"

@interface AvatarImageCell : UITableViewCell
@property (nonatomic, strong) PPRoundedImageView *roundedImageView;
@end

@implementation AvatarImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (NSInteger i = 0; i < 7; i++) {
            self.roundedImageView = [[PPRoundedImageView alloc] initWithFrame:CGRectMake(i * 45, 5, 40, 40)];
            self.roundedImageView.cornerRadius = 20;
            self.roundedImageView.userInteractionEnabled = YES;
            self.roundedImageView.roundedCorners = UIRectCornerAllCorners;
            self.roundedImageView.image = [UIImage imageNamed:@"avatar"];
            [self.roundedImageView addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.roundedImageView];
        }
    }
    return self;
}

- (void)tapImageView:(PPRoundedImageView *)imageView
{
    NSLog(@"%@", imageView);
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
    AvatarImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kAvatarImageCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

@end
