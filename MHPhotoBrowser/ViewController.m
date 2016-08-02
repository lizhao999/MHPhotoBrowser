//
//  ViewController.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "ViewController.h"
#import "MHDataSourceModel.h"
#import "MHPhotoView.h"
#import "MHPhotoModel.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MHDataSourceModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *_srcStringArray = @[
                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
                        ];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CelIdentifier];
    self.tableView.rowHeight = 400;
    self.model = [[MHDataSourceModel alloc] initWithItems:@[@"",@"",@""] cellIdentifier:CelIdentifier configureCellBlock:^(UITableViewCell *cell, id model, NSIndexPath *indexPath) {
//        cell.textLabel.text = @"你哈珀";
        MHPhotoView *photoGroup = [[MHPhotoView alloc] init];
        
        NSMutableArray *temp = [NSMutableArray array];
        [_srcStringArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            MHPhotoModel *item = [[MHPhotoModel alloc] init];
            item.thumbnail_img = src;
            [temp addObject:item];
        }];
        
        photoGroup.photoArray = [temp copy];
        [cell.contentView addSubview:photoGroup];
        
    }];
    self.tableView.dataSource = _model;
    // Do any additional setup after loading the view, typically from a nib.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
