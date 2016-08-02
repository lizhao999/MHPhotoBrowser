//
//  MHPhotoActionSheet.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/27.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPhotoSelectModel.h"

typedef NS_ENUM(NSUInteger, MHPhotoActionSheetMode) {
    MHPhotoActionSheetModeNone,   //正常显示ActionSheet  默认
    MHPhotoActionSheetModeImageList,   //ActionSheet  顶部显示图片选择
};

NS_ASSUME_NONNULL_BEGIN

@interface MHPhotoActionSheet : UIViewController


+ (MHPhotoActionSheet *)shared;


//@property (nonatomic,assign)MHPhotoActionSheetMode mode;
/**
 *   @brief 最多选择数量 default 10
 */
@property (nonatomic, assign) NSInteger maxSelectCount;

/**
 *   @brief 预览图最大显示数 default 20
 */
@property (nonatomic, assign) NSInteger maxPreviewCount;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;


-(void)showInView:(UIView *)view
          animate:(BOOL)animate
photoActionSheetMode:(MHPhotoActionSheetMode )mode
selectedPhotoModels:(NSArray<MHPhotoSelectModel *> *_Nullable)selectedPhotoModels
       completion:(void (^)(NSArray <UIImage *> *imageList, NSArray<MHPhotoSelectModel *> *selectPhotoModels ))completion;


@end
NS_ASSUME_NONNULL_END
