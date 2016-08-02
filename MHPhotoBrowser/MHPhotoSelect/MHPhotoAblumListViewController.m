//
//  MHPhotoAblumListViewController.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/28.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHPhotoAblumListViewController.h"
#import "MHPhotoBrowserConfig.h"
#import "MHPhotoTool.h"
#import "MHPhotoAblumList.h"
#import "MHPhotoAllThumbnailViewController.h"
@interface MHPhotoAblumListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray<MHPhotoAblumList *> *_arrayDataSources;
}

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation MHPhotoAblumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    _arrayDataSources = [NSMutableArray arrayWithArray:[[MHPhotoTool shared] getPhotoAblumList]];
    [self pushAllPhotoThumbnail];

    [self setupTableview];
//    _arrayDataSources = [NSMutableArray array];
    [self initNavBtn];
    // Do any additional setup after loading the view.
}

-(void)setupTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];

}

#pragma mark - 直接push到所有照片界面
- (void)pushAllPhotoThumbnail
{
    NSInteger i = 0;
    for (MHPhotoAblumList *ablum in _arrayDataSources) {
        if (ablum.assetCollection.assetCollectionSubtype == 209 || [ablum.title isEqualToString:@"所有照片"]) {
//            i = [_arrayDataSources indexOfObject:ablum];
            
//            MHPhotoAblumList *ablum = _arrayDataSources[i];
            
            MHPhotoAllThumbnailViewController *photoAllThumbnailVC = [[MHPhotoAllThumbnailViewController alloc] init];
            photoAllThumbnailVC.maxSelectCount = self.maxSelectCount;
            
            photoAllThumbnailVC.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
            //    tvc.assetCollection = ablum.assetCollection;
            photoAllThumbnailVC.arraySelectPhotos = self.arraySelectPhotos;
            photoAllThumbnailVC.photoAblumList = ablum;
            //    tvc.sender = self;
            photoAllThumbnailVC.DoneBlock = self.DoneBlock;
            photoAllThumbnailVC.CancelBlock = self.CancelBlock;
            [self.navigationController pushViewController:photoAllThumbnailVC animated:NO];
            
            break;
        }
    }

    
}
//- (void)loadAblums
//{
//    [_arrayDataSources addObjectsFromArray:[[MHPhotoTool shared] getPhotoAblumList]];
//}

- (void)initNavBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.hidesBackButton = YES;
}

- (void)navRightBtnClick
{
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MHPhotoAblumList *ablumList= _arrayDataSources[indexPath.row];

    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    line.frame = CGRectMake(0, 0, tableView.bounds.size.width, 1);
//    [cell addSubview:line];
    cell.imageView.frame = CGRectMake(8, 5, 60, 60);

    [[MHPhotoTool shared] requestImageForAsset:ablumList.headImageAsset size:CGSizeMake(65*3, 65*3) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
//        cell.imageView.image = image;
        CGSize itemSize = CGSizeMake(60, 60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    }];
    
    cell.textLabel.text = ablumList.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld)", ablumList.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    MHPhotoAblumList *ablum = _arrayDataSources[indexPath.row];
    
    MHPhotoAllThumbnailViewController *photoAllThumbnailVC = [[MHPhotoAllThumbnailViewController alloc] init];
    photoAllThumbnailVC.maxSelectCount = self.maxSelectCount;
    
//    tvc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
//    tvc.assetCollection = ablum.assetCollection;
    photoAllThumbnailVC.arraySelectPhotos = self.arraySelectPhotos;
    photoAllThumbnailVC.photoAblumList = ablum;
//    tvc.sender = self;
    photoAllThumbnailVC.DoneBlock = self.DoneBlock;
    photoAllThumbnailVC.CancelBlock = self.CancelBlock;
    [self.navigationController pushViewController:photoAllThumbnailVC animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
