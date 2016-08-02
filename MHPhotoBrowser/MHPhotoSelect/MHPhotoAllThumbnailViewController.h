//
//  MHPhotoAllThumbnailViewController.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/29.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAssetCollection;
@class MHPhotoSelectModel;
@class MHPhotoAblumList;
@interface MHPhotoAllThumbnailViewController : UIViewController

/**
 *   @brief 当前已经选择的图片
 */
@property (nonatomic, strong) NSMutableArray<MHPhotoSelectModel *> *arraySelectPhotos;
/**
 *   @brief 最大选择数
 */
@property (nonatomic, assign) NSInteger maxSelectCount;

/**
 *   @brief 是否选择了原图
 */
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;


@property (nonatomic, retain)  MHPhotoAblumList *photoAblumList;

@property (nonatomic, retain)  UICollectionView *collectionView;

@property (nonatomic, copy) void (^DoneBlock)(NSArray<MHPhotoSelectModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);

@property (nonatomic, copy) void (^CancelBlock)();

//相册属性
//@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
