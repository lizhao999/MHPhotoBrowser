//
//  MHProgressView.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPhotoBrowserConfig.h"

@interface MHProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) MHWaitingViewMode mode;
@end
