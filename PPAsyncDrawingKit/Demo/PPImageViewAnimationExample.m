//
//  PPImageViewAnimationExample.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2017/2/7.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

#import "PPImageViewAnimationExample.h"
#import "PPImageView.h"
#import "UIView+Frame.h"
#import "PPImageDecode.h"

@interface AnimationImageViewCell : UICollectionViewCell
@property (nonatomic, strong) PPImageView *imageView;
@end

@implementation AnimationImageViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[PPImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return self;
}
@end

@interface PPImageViewAnimationExample () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation PPImageViewAnimationExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"download" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _image = [PPImageDecode animatedGIFWithData:data];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat wh = (self.view.width - 1.0f * 2.0f) / 3.0f;
    layout.itemSize = CGSizeMake(wh, wh);
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 1.0f;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[AnimationImageViewCell class] forCellWithReuseIdentifier:@"AnimationImageViewCell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimationImageViewCell" forIndexPath:indexPath];
    [cell.imageView setFinalImage:_image isGIf:YES];
    return cell;
}

@end
