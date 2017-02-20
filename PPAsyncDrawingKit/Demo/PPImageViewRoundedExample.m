//
//  ImageViewTableViewController.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPImageViewRoundedExample.h"
#import "PPImageView.h"
#import "UIView+Frame.h"

@interface PPImageViewCell : UICollectionViewCell
@property (nonatomic, strong, readonly) PPImageView *imageView;
@end

@implementation PPImageViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[PPImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.cornerRadius = frame.size.width / 2.0f;
        _imageView.borderWidth = 0.1f;
        _imageView.borderColor = [UIColor blackColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}
@end

@interface PPImageViewRoundedExample () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PPImageViewRoundedExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat wh = (self.view.width - 1.0f * 4.0f) / 5.0f;
    layout.itemSize = CGSizeMake(wh, wh);
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 1.0f;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PPImageViewCell class] forCellWithReuseIdentifier:@"PPImageViewCell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PPImageViewCell" forIndexPath:indexPath];
    // 在低端设备上，绘制速度跟不上滑动速度，会出现白屏。
    // 如果白屏影响体验，可以设置 clearsContextBeforeDrawing 为 NO，在绘制完成之前会使用之前绘制好的 content。
    // 注意：在每次绘制完成后 clearsContextBeforeDrawing 会设置成默认值 YES。
    // 会降低一点点性能
    cell.imageView.clearsContextBeforeDrawing = NO;
    cell.imageView.image = [UIImage imageNamed:@"avatar"];
    return cell;
}

@end
