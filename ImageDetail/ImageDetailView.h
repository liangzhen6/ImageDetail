//
//  ImageDetailView.h
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailView : UIView

+ (id)imageDetailViewWithUrlStrs:(NSArray<NSString *> *)imagesUrlArr originImageViews:(NSArray<UIImageView *> *)originImageViews;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,copy)NSArray <NSString *>* imagesUrlArr;
@property(nonatomic,copy)NSArray <UIImageView *>* originImageViewArr;
- (void)showView;
- (void)dismissView;
@end
