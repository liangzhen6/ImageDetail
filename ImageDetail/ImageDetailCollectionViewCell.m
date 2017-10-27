//
//  ImageDetailCollectionViewCell.m
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ImageDetailCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageModel.h"

#define IOS_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]
#define Screen_Frame     [[UIScreen mainScreen] bounds]
#define Screen_Width     [[UIScreen mainScreen] bounds].size.width
#define Screen_Height    [[UIScreen mainScreen] bounds].size.height

@interface ImageDetailCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *ImageView;
//@property (nonatomic,assign) CGPoint imageCenter;

@end

@implementation ImageDetailCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView {
    
    [self.contentView addSubview:self.scrollView];
    _ImageView = [[UIImageView alloc] init];
    _ImageView.center = CGPointMake(Screen_Width / 2, Screen_Height / 2);
    [self.scrollView addSubview:_ImageView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.scrollView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    

}



#pragma mark========tapAction==============
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.ImageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}


#pragma mark ====返回需要缩放的控件================
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.ImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.ImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


- (void)updateImageSize
{
    [_scrollView setZoomScale:1.0 animated:NO];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imgWidth = self.model.size.width;
    CGFloat imgHeight = self.model.size.height;
    if (imgWidth < width) {
        _ImageView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
        _scrollView.contentSize = CGSizeMake(width, imgHeight);
    }else {
        imgHeight = width / imgWidth * imgHeight;
        _ImageView.frame = CGRectMake(0, 0, width, imgHeight);
        _scrollView.contentSize = CGSizeMake(width, imgHeight);
        _ImageView.center = CGPointMake(width / 2, imgHeight / 2);
    }
    
    if (imgHeight > height) {
        _ImageView.center = CGPointMake(width / 2, imgHeight / 2);
    }else {
        _ImageView.center = CGPointMake(width / 2, height / 2);
    }
}

- (void)setModel:(ImageModel *)model {
    _model = model;
    CGFloat WH = Screen_Width/Screen_Height;
    
//    NSLog(@"%@",model.url);
    __weak typeof (self)ws = self;
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:model.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            CGFloat imageWH = image.size.width/image.size.height;
            CGRect frame = ws.ImageView.frame;
            if (WH>imageWH) {
                frame.size = CGSizeMake(Screen_Height *imageWH, Screen_Height);
                model.size = frame.size;
                
            }else{
                frame.size = CGSizeMake(Screen_Width, Screen_Width/imageWH);
                model.size = frame.size;
            }
            ws.scrollView.contentSize = frame.size;
            ws.ImageView.frame = frame;
            ws.ImageView.center = CGPointMake(Screen_Width / 2, Screen_Height / 2);
        }
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView==nil) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
    
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(width, height);
        _scrollView.userInteractionEnabled = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;

    }
    return _scrollView;
}

- (void)changeSize:(CGFloat)multiple centerY:(CGFloat)centerY {
    _scrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    _scrollView.center = CGPointMake(Screen_Width/2, Screen_Height/2+centerY);
}


@end
