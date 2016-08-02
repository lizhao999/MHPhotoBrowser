//
//  MHPhotoSelectConfig.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/27.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#ifndef MHPhotoSelectConfig_h
#define MHPhotoSelectConfig_h

#define CollectionName [[NSBundle mainBundle].infoDictionary valueForKey:(__bridge NSString *)kCFBundleNameKey]

#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var

#define kMHPhotoSrcName(file) [@"MHPhoto.bundle" stringByAppendingPathComponent:file]

//#define MYBUNDLE_NAME @ "MHPhoto.bundle"
//#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
//#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#define kViewWidth      [[UIScreen mainScreen] bounds].size.width
//如果项目中设置了导航条为不透明，即[UINavigationBar appearance].translucent=NO，那么这里的kViewHeight需要-64
#define kViewHeight     [[UIScreen mainScreen] bounds].size.height

////////ZLPhotoActionSheet
#define kBaseViewHeight 300

static inline CAKeyframeAnimation * GetBtnStatusChangedAnimation() {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animate.duration = 0.3;
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    animate.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    return animate;
}

#endif /* MHPhotoSelectConfig_h */
