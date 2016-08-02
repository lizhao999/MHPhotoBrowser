//
//  MHDataSourceModel.h
//  MHTableViewDatasource
//
//  Created by 李钊 on 16/7/18.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *CelIdentifier = @"CellIdentifier";

typedef void(^CellConfigureBlock)(id cell, id model, NSIndexPath *indexPath);

@interface MHDataSourceModel : NSObject<UITableViewDataSource,UICollectionViewDataSource>

//@property (nonatomic, assign) float rowHeight;


- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
     configureCellBlock:(CellConfigureBlock)aConfigureCellBlock;
@end
