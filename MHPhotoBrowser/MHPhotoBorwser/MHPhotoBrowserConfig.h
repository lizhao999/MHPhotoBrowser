//
//  MHPhotoBrowserConfig.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#ifndef MHPhotoBrowserConfig_h
#define MHPhotoBrowserConfig_h

typedef enum {
    MHWaitingViewModeLoopDiagram, // 默认 环形
    MHWaitingViewModePieDiagram // 饼型
} MHWaitingViewMode;

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

#define kAnimationDuration 0.35f

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

//是否支持横屏
#define shouldLandscape YES

// 图片保存成功提示文字
#define MHPhotoBrowserSaveImageSuccessText @" 保存成功 ";

// 图片保存失败提示文字
#define MHPhotoBrowserSaveImageFailText @" 保存失败 ";

// browser背景颜色
#define MHPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

// browser中图片间的margin
#define MHPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define MHPhotoBrowserShowImageAnimationDuration 0.35f

// browser中隐藏图片动画时长
#define MHPhotoBrowserHideImageAnimationDuration 0.35f

// 图片下载进度指示进度显示样式（MHWaitingViewModeLoopDiagram 环形，MHWaitingViewModePieDiagram 饼型）
#define MHWaitingViewProgressMode MHWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define MHWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
//#define MHWaitingViewBackgroundColor [UIColor clearColor]

// 图片下载进度指示器内部控件间的间距
#define MHWaitingViewItemMargin 10







#endif /* MHPhotoBrowserConfig_h */
