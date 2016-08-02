//
//  MHPhotoAblumListViewController.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/28.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection;
@class MHPhotoSelectModel;
@class MHPhotoAblumList;

@interface MHPhotoAblumListViewController : UIViewController
/**
 *   @brief 当前已经选择的图片
 */
@property (nonatomic, strong) NSMutableArray<MHPhotoSelectModel *> *arraySelectPhotos;

/**
 *   @brief 是否选择了原图
 */
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
/**
 *   @brief 最大选择数
 */
@property (nonatomic, assign) NSInteger maxSelectCount;


@property (nonatomic, copy) void (^DoneBlock)(NSArray<MHPhotoSelectModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);

@property (nonatomic, copy) void (^CancelBlock)();

@end
