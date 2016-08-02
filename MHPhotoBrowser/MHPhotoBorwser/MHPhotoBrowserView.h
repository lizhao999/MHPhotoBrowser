//
//  MHPhotoBrowserView.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHPhotoBrowserView : UIView

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL beginLoadingImage;

//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;


@end
