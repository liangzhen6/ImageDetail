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
@property(nonatomic,assign)CGSize size;
@property(nonatomic,weak)UIImageView *imageView;

@end
