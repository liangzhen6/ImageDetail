//
//  ViewController.m
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "ImageDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define IOS_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]
#define Screen_Frame     [[UIScreen mainScreen] bounds]
#define Screen_Width     [[UIScreen mainScreen] bounds].size.width
#define Screen_Height    [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
@property(nonatomic,strong)ImageDetailView * myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

- (void)initView {
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:Screen_Frame];
    [self.view addSubview:scrollView];
    
    [scrollView setContentSize:CGSizeMake(0, 1200)];
    
    CGFloat W = (Screen_Width-20-10)/3;
    NSArray * images =  @[@"http://olxnvuztq.bkt.clouddn.com/s01.jpg",@"http://olxnvuztq.bkt.clouddn.com/s02.jpg",@"http://olxnvuztq.bkt.clouddn.com/s03.jpg",@"http://olxnvuztq.bkt.clouddn.com/s04.jpg",@"http://olxnvuztq.bkt.clouddn.com/s05.jpg",@"http://olxnvuztq.bkt.clouddn.com/s06.jpg"];;
    NSInteger count = (images.count)%3?(images.count/3+1):images.count/3;
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, Screen_Width-20, count*W + (count-1)*5)];
    [scrollView addSubview:backView];
    backView.backgroundColor = [UIColor grayColor];
    NSMutableArray * originImageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < images.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i%3)*(W+5), i/3*(W+5), W, W)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (error == nil) {
//                
//            }
//        }];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [backView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouchAction:)];
        [imageView addGestureRecognizer:tap];
        [originImageViews addObject:imageView];
    }
    
   
}

- (void)imageTouchAction:(UIGestureRecognizer *)ges {
    NSArray * images = @[@"http://olxnvuztq.bkt.clouddn.com/b01.jpg",@"http://olxnvuztq.bkt.clouddn.com/b02.jpg",@"http://olxnvuztq.bkt.clouddn.com/b03.jpg",@"http://olxnvuztq.bkt.clouddn.com/b04.jpg",@"http://olxnvuztq.bkt.clouddn.com/b05.jpg",@"http://olxnvuztq.bkt.clouddn.com/b06.jpg"];
     _myView = [ImageDetailView imageDetailViewWithUrlStrs:images originImageViews:ges.view.superview.subviews];
    NSLog(@"%ld",(long)ges.view.tag);
    _myView.currentPage = ges.view.tag;
    
    [_myView showView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
