//
//  MHPhotoView.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHPhotoView.h"
#import "MHPhotoModel.h"
#import "UIButton+WebCache.h"
#import "MHPhotoBrowser.h"
#define MHPhotoImageMargin 15
#define MHPhotoImageTitleHeight 20
@interface MHPhotoView () <MHPhotoBrowserDelegate>

@end
@implementation MHPhotoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
//        [[SDWebImageManager sharedManager].imageCache clearDisk];

    }
    return self;

}

-(void)setPhotoArray:(NSArray *)photoArray
{
    _photoArray = photoArray;
    
    [photoArray enumerateObjectsUsingBlock:^(MHPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeLeft|UIViewContentModeRight;
        btn.clipsToBounds = YES;
//        btn.backgroundColor = [UIColor redColor];
        if (obj.imgData) {
            [btn setImage:[UIImage imageWithData:obj.imgData] forState:UIControlStateNormal];
        }else
        {
            [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
        }
        
        btn.tag = idx;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (obj.imgTitle) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height-MHPhotoImageTitleHeight, btn.frame.size.width, MHPhotoImageTitleHeight)];
            view.backgroundColor = [UIColor colorWithRed:0.2669 green:0.2669 blue:0.2669 alpha:0.36];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            titleLabel.text = obj.imgTitle;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
            [view addSubview:titleLabel];
            [btn addSubview:titleLabel];
        }
        [self addSubview:btn];
    }];
    
}

- (void)layoutSubviews
{

    [super layoutSubviews];
 
    long imageCount = self.photoArray.count;
    
    int perRowImageCount = ((imageCount == 4) ? 2.0 : MHPhotoImageRowNumber); //如果数组有4个 则每行显示2个
    
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
    CGFloat w,h;
    if (self.imgSize.width<=0) {
        
        w = ([UIScreen mainScreen].bounds.size.width - 2*MHPhotoImageMargin-20)/3;
        h = ([UIScreen mainScreen].bounds.size.width - 2*MHPhotoImageMargin-20)/3 ;
    }else
    {
        w = self.imgSize.width;
        h = self.imgSize.height;
    }
    
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + MHPhotoImageMargin);
        CGFloat y = rowIndex * (h + MHPhotoImageMargin);
        btn.frame = CGRectMake(x, y, w, h);
        NSLog(@"%@",NSStringFromCGSize(btn.frame.size));
    }];
    
    self.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, totalRowCount * (MHPhotoImageMargin + h));
}

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    MHPhotoBrowser *browser = [[MHPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoArray.count; // 图片总数
    browser.currentImageIndex = (int)button.tag;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(MHPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(MHPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoArray[index] thumbnail_img] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    return [NSURL URLWithString:urlStr];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
