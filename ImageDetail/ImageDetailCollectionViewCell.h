//
//  ImageDetailCollectionViewCell.h
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageModel;
typedef void(^CollectionBackAlphaBlock) (CGFloat alpha);

@interface ImageDetailCollectionViewCell : UICollectionViewCell
@property(nonatomic,copy)void(^dismissBlock)();
@property(nonatomic,strong)ImageModel * model;
@property(nonatomic,copy)CollectionBackAlphaBlock backAlphaBlock;

- (void)updateImageSize;
- (void)changeSize:(CGFloat)multiple centerY:(CGFloat)centerY;

//- (CGRect)imageViewframeOnScrollView;
//
//- (UIImage *)currentImage;
//
//- (UIImageView *)currentImageView;
@end
