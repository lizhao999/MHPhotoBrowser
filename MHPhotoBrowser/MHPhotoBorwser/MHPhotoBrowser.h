//
//  MHPhotoBrowser.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZButton, MHPhotoBrowser;

@protocol MHPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(MHPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(MHPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end
@interface MHPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<MHPhotoBrowserDelegate> delegate;

- (void)show;

@end
