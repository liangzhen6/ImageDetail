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
#import "ImageHeader.h"

@interface ImageDetailCollectionViewCell ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *ImageView;
@property(nonatomic,assign)NSInteger numberFinger;
@property(nonatomic,assign)BOOL startRun;
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
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint point = scrollView.contentOffset;
    //只有是一根手指事件才做出响应。
    if (point.y < 0 && _numberFinger == 1) {
        if (velocity.y < 0) {
            _startRun = NO;
            //如果是向下滑动才触发消失的操作。
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        } else {
            [self changeSize:1.0 centerY:0.0];
            if (self.backAlphaBlock) {
                self.backAlphaBlock(1.0);
            }
        }

    } else {
        [self changeSize:1.0 centerY:0.0];
        if (self.backAlphaBlock) {
            self.backAlphaBlock(1.0);
        }
    }
    _numberFinger = 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _numberFinger = scrollView.panGestureRecognizer.numberOfTouches;
    _startRun = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   CGPoint point = scrollView.contentOffset;
    //只有是一根手指事件才做出响应。
    if ((point.y < 0 && _numberFinger == 1 ) && _startRun) {
        CGFloat flo = (Screen_Height + point.y)/Screen_Height;
        [self changeSize:flo centerY:-point.y];
        if (self.backAlphaBlock) {
            self.backAlphaBlock(flo);
        }
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


- (void)updateImageSize {
    [_scrollView setZoomScale:1.0 animated:NO];
    
    CGFloat imageW = self.model.bigImageSize.width;
    CGFloat imageH = self.model.bigImageSize.height;
    
    CGFloat height =  Screen_Width * imageH/imageW;
    if (imageH/imageW > Screen_Height/Screen_Width) {
        //长图
        _ImageView.frame =CGRectMake(0, 0, Screen_Width, height);
    } else {
        _ImageView.frame =CGRectMake(0, Screen_Height/2 - height/2, Screen_Width, height);
    }
    _scrollView.contentSize = CGSizeMake(Screen_Width, height);
    
}

- (void)setModel:(ImageModel *)model {
    _model = model;
    model.bigScrollView = _scrollView;
    model.bigImageView = _ImageView;
    __weak typeof (self)ws = self;
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:model.urlStr] placeholderImage:model.smallImageView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            [ws updateImageSize];
        }
    }];
    [self updateImageSize];

}

- (UIScrollView *)scrollView {
    if (_scrollView==nil) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
    
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;//最大放大倍数
        _scrollView.minimumZoomScale = 1.0;//最小缩小倍数
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(width, height);
        _scrollView.userInteractionEnabled = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsVerticalScrollIndicator = NO;

    }
    return _scrollView;
}

- (void)changeSize:(CGFloat)multiple centerY:(CGFloat)centerY {
    NSLog(@"%f---%f",multiple,centerY);
    multiple = multiple>0.4?multiple:0.4;
    _scrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    _scrollView.center = CGPointMake(Screen_Width/2, Screen_Height/2+centerY);
}

//- (CGRect)imageViewframeOnScrollView {
//    CGRect scrollViewFrame = _scrollView.frame;
//    CGFloat H = scrollViewFrame.size.width * _ImageView.image.size.height/_ImageView.image.size.width;
//    CGPoint center = _scrollView.center;
//    return CGRectMake(center.x - scrollViewFrame.size.width/2, center.y - H/2, scrollViewFrame.size.width, H);
//}
//
//- (UIImage *)currentImage {
//    return _ImageView.image;
//}
//- (UIImageView *)currentImageView {
//    return _ImageView;
//}

@end
