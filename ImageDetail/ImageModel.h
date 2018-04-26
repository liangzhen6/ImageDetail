//
//  ImageModel.h
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageModel : NSObject
@property(nonatomic,copy)NSString * url;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic,weak)UIImageView *imageView;
//在原始的window上的frame
- (CGRect)imageViewframeOriginWindow;
//图片放大后充满屏幕后的frame
- (CGRect)imageViewframeShowWindow;
@end
