//
//  MHPhotoTool.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/28.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MHPhotoAblumList.h"

@interface MHPhotoTool : NSObject

+(instancetype)shared;
/**
 * @brief 获取用户所有相册列表
 */
- (NSArray<MHPhotoAblumList *> *)getPhotoAblumList;

/**
 * @brief 获取相册内所有图片资源
 * @param ascending 是否按创建时间正序排列 YES,创建时间正（升）序排列; NO,创建时间倒（降）序排列
 */
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;


/**
 * @brief 获取指定相册内的所有图片
 */
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

/**
 * @brief 获取每个Asset对应的图片
 * @param size  需要获取的图像的尺寸，如果输入的尺寸大于资源原图的尺寸，则只返回原图。需要注意在 PHImageManager 中，所有的尺寸都是用 Pixel 作为单位（Note that all sizes are in pixels），因此这里想要获得正确大小的图像，需要把输入的尺寸转换为 Pixel。如果需要返回原图尺寸，可以传入 PhotoKit 中预先定义好的常量?PHImageManagerMaximumSize，表示返回可选范围内的最大的尺寸，即原图尺寸。
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image, NSDictionary *info))completion;
/**
 *   @param progress 进度 0 - 1
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode progress:(void (^)(double progress))progress completion:(void (^)(UIImage *image, NSDictionary *info))completion;

/**
 *   @brief 获取 Asset对应的图片
 *
 *   @param asset
 *   @param scale      缩放系数 UIImageJPEGRepresentation
 *   @param resizeMode
 *   @param completion  
 */
- (void)requestImageForAsset:(PHAsset *)asset scale:(CGFloat)scale resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

/**
 * @brief 保存图片到系统相册
 */
- (void)saveImageToAblum:(UIImage *)image completion:(void (^)(BOOL suc, PHAsset *asset))completion;

/**
 * @brief 获取数组内图片的字节大小
 */
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *photosBytes))completion;


/**
 * @brief 判断图片是否存储在本地/或者已经从iCloud上下载到本地
 */
- (BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset;

#pragma mark - 判断软件是否有相册访问权限
+ (BOOL)judgeIsHavePhotoAblumAuthority;
#pragma mark - 判断软件是否有相机访问权限
+ (BOOL)judgeIsHaveCameraAuthority;

@end
