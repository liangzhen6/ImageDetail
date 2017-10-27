//
//  ImageDetailCollectionViewCell.h
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageModel;
@interface ImageDetailCollectionViewCell : UICollectionViewCell
@property(nonatomic,copy)void(^dismissBlock)();
@property(nonatomic,strong)ImageModel * model;
- (void)updateImageSize;
- (void)changeSize:(CGFloat)multiple centerY:(CGFloat)centerY;
@end
