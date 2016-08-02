//
//  MHPhotoBrowserViewController.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/29.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class MHPhotoSelectModel;
@interface MHPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) NSArray<PHAsset *> *assets;


@property (nonatomic, strong) NSMutableArray<MHPhotoSelectModel *> *arraySelectPhotos;

@property (nonatomic, assign) NSInteger maxSelectCount;
/**
 *   @brief 是否选择了原图
 */
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

/**
 *   @brief 选中的图片下标
 */
@property (nonatomic, assign) NSInteger selectIndex;
/**
 *   @brief 是否需要对接收到的图片数组进行逆序排列
 */
@property (nonatomic, assign) BOOL shouldReverseAssets; //

@property (nonatomic, copy) void (^backPhotos)(NSArray<MHPhotoSelectModel *> *, BOOL isSelectOriginalPhoto); //点击返回按钮的回调

@property (nonatomic, copy) void (^DoneBlock)(NSArray<MHPhotoSelectModel *> *, BOOL isSelectOriginalPhoto); //点击确定按钮回调

@end
