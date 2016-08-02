//
//  MHDataSourceModel.m
//  MHTableViewDatasource
//
//  Created by 李钊 on 16/7/18.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHDataSourceModel.h"

@interface MHDataSourceModel()
///数据
@property(nonatomic, strong) NSArray* items;

@property(nonatomic, copy) NSString* cellIdentifier;
@property(nonatomic, copy) CellConfigureBlock configureCellBlock;

@end


@implementation MHDataSourceModel

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(CellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
        _items = anItems;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return _items[(NSUInteger) indexPath.row];
}

#pragma mark - UITableViewDataSource Delegate
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    if (self.configureCellBlock) {
       
        self.configureCellBlock(cell,_items[indexPath.row],indexPath);
    }
    return cell;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
     if (self.configureCellBlock) {
        
        self.configureCellBlock(cell,_items[indexPath.row],indexPath);
    }
    return cell;
}

@end
