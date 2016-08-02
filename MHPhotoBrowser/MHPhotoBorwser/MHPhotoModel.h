//
//  MHPhotoItem.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MHPhotoModel : NSObject
/**
 *   @brief 缩略图Url
 */
@property (nonatomic, copy) NSString *thumbnail_img;
/**
 *   @brief 原图Url
 */
@property (nonatomic, copy) NSString *img;

/**
 *   @brief 本地图片数据
 */
@property (nonatomic, copy) NSData *imgData;

/**
 *   @brief 图片标题
 */
@property (nonatomic,retain)NSString *imgTitle;


@end
