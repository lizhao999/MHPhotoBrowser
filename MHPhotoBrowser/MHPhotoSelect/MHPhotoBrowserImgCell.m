//
//  MHPhotoBrpwserImgCell.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/29.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHPhotoBrowserImgCell.h"
#import <Photos/Photos.h>
#import "MHPhotoTool.h"
#import "MHProgressView.h"
@interface MHPhotoBrowserImgCell () <UIScrollViewDelegate>
#define kScreenWidth      [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight     [[UIScreen mainScreen] bounds].size.height
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) MHProgressView *progressView;

@end
@implementation MHPhotoBrowserImgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.containerView];
        [self.containerView addSubview:self.imageView];

    }
    return self;
}
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [_scrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return _scrollView;
}
- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.hidesWhenStopped = YES;
        _indicator.center = self.contentView.center;
    }
    return _indicator;
}
-(MHProgressView *)progressView
{
    if (!_progressView) {
         _progressView = [[MHProgressView alloc] init];
        _progressView.mode = MHWaitingViewModeLoopDiagram;
        _progressView.center = self.contentView.center;
    }
    return _progressView;
}

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([[UIScreen mainScreen] bounds].size.width, 500);
    CGSize size = CGSizeMake(width*scale, width*scale*_asset.pixelHeight/_asset.pixelWidth);
    

//    [self.indicator startAnimating];
    __weak typeof(self) weakSelf = self;

//    [[MHPhotoTool shared] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
//         weakSelf.imageView.image = image;
//        [weakSelf resetSubviewSize];
//        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
//            [weakSelf.indicator stopAnimating];
//        }
//    }];
    [self addSubview:self.progressView];

 
    [[MHPhotoTool shared] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast progress:^(double progress) {
        NSLog(@"%.2f",progress);
        __strong __typeof(weakSelf)strongSelf = weakSelf;


        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.progressView.hidden = NO;
            strongSelf.progressView.progress = progress;

        });
        
    } completion:^(UIImage *image, NSDictionary *info) {
        if (!image) {
            return ;
        }
        
        weakSelf.imageView.image = image;
        [weakSelf resetSubviewSize];
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
//            [weakSelf.indicator stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.progressView.hidden = YES;
                [strongSelf.progressView removeFromSuperview];
                strongSelf.progressView = nil;
            });
          
        }
    }];
}

- (void)resetSubviewSize
{
    CGRect frame;
    frame.origin = CGPointZero;
    
    UIImage *image = self.imageView.image;
    CGFloat imageScale = image.size.height/image.size.width;
    CGFloat screenScale = [[UIScreen mainScreen] bounds].size.height/[[UIScreen mainScreen] bounds].size.width;
//    if (image.size.width <= self.frame.size.width && image.size.height <= self.frame.size.height) {
//        frame.size.width = image.size.width;
//        frame.size.height = image.size.height;
//    } else {
        if (imageScale > screenScale) {
            frame.size.height = self.frame.size.height;
            frame.size.width = self.frame.size.height/imageScale;
        } else {
            frame.size.width = self.frame.size.width;
            frame.size.height = self.frame.size.width * imageScale;
        }
//    }
    
    self.scrollView.zoomScale = 1;
    self.scrollView.contentSize = frame.size;
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.containerView.frame = frame;
    self.containerView.center = self.scrollView.center;
    self.imageView.frame = self.containerView.bounds;
}

 

#pragma mark - 手势点击事件
- (void)singleTapAction:(UITapGestureRecognizer *)singleTap
{
    if (self.singleTapCallBack) self.singleTapCallBack();
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3.0) {
        scale = 3;
    } else {
        scale = 1;
    }
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
