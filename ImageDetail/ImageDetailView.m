//
//  ImageDetailView.m
//  ImageDetail
//
//  Created by shenzhenshihua on 2017/3/21.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ImageDetailView.h"
#import "ImageDetailCollectionViewCell.h"
#import "ImageModel.h"
#import "ImageHeader.h"

NSString * const registerId = @"collectionCell";

@interface ImageDetailView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * imageViewsPoint;
@property(nonatomic,strong)NSMutableArray * imageViewsImage;
@property(nonatomic,strong)ImageDetailCollectionViewCell * currentCell;

@end

@implementation ImageDetailView

+ (id)imageDetailViewWithUrlStrs:(NSArray<NSString *> *)imagesUrlArr originImageViews:(NSArray<UIImageView *> *)originImageViews {
     ImageDetailView * imageDetail = [[ImageDetailView alloc] initWithFrame:Screen_Frame];
    imageDetail.originImageViewArr = originImageViews;
    imageDetail.imagesUrlArr = imagesUrlArr;
    [imageDetail initData];
    return imageDetail;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initData {

    //1.初始化原始的数据
    self.dataSource = [[NSMutableArray alloc] init];
    for (NSString * str in self.imagesUrlArr) {
        ImageModel * model = [[ImageModel alloc] init];
        model.url = str;
        [self.dataSource addObject:model];
    }
}

- (void)showView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    UIImageView * originImageView = self.originImageViewArr[self.currentPage];
    CGRect frame = [originImageView convertRect:originImageView.bounds toView:originImageView.window];

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

    imageView.image = originImageView.image;
    [self addSubview:imageView];
    
    CGFloat imageW = imageView.image.size.width;
    CGFloat imageH = imageView.image.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = Screen_Width;
        frame.size.height = Screen_Width * imageH/imageW;
        imageView.frame = frame;
        imageView.center = CGPointMake(Screen_Width/2, Screen_Height/2);
    } completion:^(BOOL finished) {
        self.collectionView.hidden = NO;
        self.pageControl.hidden = NO;
        [imageView removeFromSuperview];
    }];


}
- (void)dismissView {
    ImageDetailCollectionViewCell * cell = [self getCurrentCell];
    UIImageView * imageViewCell = [cell valueForKey:@"ImageView"];
    NSLog(@"%@",imageViewCell);
    CGRect scrollFrame = [[cell valueForKey:@"scrollView"] frame];
    CGFloat H = scrollFrame.size.width*imageViewCell.image.size.height/imageViewCell.image.size.width;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, H)];
    imageView.center = [[cell valueForKey:@"scrollView"] center];
    imageView.image = imageViewCell.image;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    self.collectionView.hidden = YES;
    self.pageControl.hidden = YES;
    
    UIImageView * originImageView = self.originImageViewArr[self.currentPage];
    CGRect frame = [originImageView convertRect:originImageView.bounds toView:originImageView.window];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        imageView.hidden = YES;
        [self removeFromSuperview];
    }];
    
}


- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    CGPoint piont = [gesture translationInView:self];
    CGFloat flo = (500 - piont.y)/500;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            {
                _currentCell = [self getCurrentCell];
                NSLog(@"开始%f%f",piont.x, piont.y);
            }
            break;
        case UIGestureRecognizerStateChanged:
            {
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:flo];
                if (flo<1 && flo>0) {
                    [_currentCell changeSize:flo centerY:piont.y];
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
            {
                //方向速度向量，y>0 证明向下移动。
                CGPoint spceVelocity = [gesture velocityInView:gesture.view];
                if (spceVelocity.y > 0) {
                    [self dismissView];
                } else {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
                        [_currentCell changeSize:1.0 centerY:0.0];
                    }];
                }
            }
            break;
            
        default:
            break;
    }

//    NSLog(@"%f%f",piont.x, piont.y);
}


- (ImageDetailCollectionViewCell *)getCurrentCell {
    
    NSInteger index = self.collectionView.contentOffset.x / Screen_Width;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    ImageDetailCollectionViewCell * currentcell = (ImageDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"%ld--%@",indexPath.row,currentcell);
    
    return currentcell;
    
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    self.pageControl.numberOfPages = self.dataSource.count;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.dataSource.count];
    self.pageControl.frame = CGRectMake(Screen_Width/2-size.width/2, Screen_Height-size.height-20, size.width, size.height);
    
    self.pageControl.currentPage = currentPage;
    self.pageControl.hidden = YES;
    self.collectionView.hidden = YES;

    
    [self.collectionView setContentOffset:CGPointMake((Screen_Width+SpaceWidth)*currentPage, 0)];

}


- (UIPageControl *)pageControl {
    if (_pageControl==nil) {
        _pageControl = [[UIPageControl alloc] init];
        //如果只有一页就隐藏
        _pageControl.hidesForSinglePage = YES;
        //设置page的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //设置当前page的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (UICollectionView *)collectionView {

    if (_collectionView==nil) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = SpaceWidth; //设置每一行的间距
        layout.sectionInset = UIEdgeInsetsMake(0,SpaceWidth/2, 0, SpaceWidth/2);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.itemSize=CGSizeMake(Screen_Width, Screen_Height);  //设置每个单元格的大小
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-SpaceWidth/2, 0, Screen_Width + SpaceWidth, Screen_Height) collectionViewLayout:layout];
        _collectionView.center = self.center;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ImageDetailCollectionViewCell class] forCellWithReuseIdentifier:registerId];
        
    }
    return _collectionView;

}


#pragma mark ================UICollectionViewDelegate====================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:registerId forIndexPath:indexPath];
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    __weak typeof (self)ws = self;
    [cell setDismissBlock:^{
        [ws dismissView];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ImageDetailCollectionViewCell class]]) {
        [(ImageDetailCollectionViewCell *)cell updateImageSize];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ImageDetailCollectionViewCell class]]) {
        [(ImageDetailCollectionViewCell *)cell updateImageSize];
    }
}

#pragma mark  ==========UICollectionView->scrollerViewDeleagte=====================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat X = scrollView.contentOffset.x;
    NSInteger page = X/(Screen_Width+SpaceWidth);
//    NSLog(@"%f-----%f-----%ld",X,Screen_Width,(long)page);
    _currentPage = page;
    [self.pageControl setCurrentPage:page];

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat X = scrollView.contentOffset.x;
    NSInteger page = X/(Screen_Width+SpaceWidth);
//    NSLog(@"%f-----%f-----%ld",X,Screen_Width,(long)page);
    _currentPage = page;
    [self.pageControl setCurrentPage:page];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
