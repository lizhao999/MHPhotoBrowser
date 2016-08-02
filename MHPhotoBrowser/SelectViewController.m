




//
//  SelectViewController.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/27.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "SelectViewController.h"
#import "MHPhotoActionSheet.h"
@interface SelectViewController ()

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectclick:(id)sender {
//    [self performSegueWithIdentifier:@"selecta" sender:self];

    MHPhotoActionSheet *s = [MHPhotoActionSheet shared];
    [s showInView:self.view animate:YES photoActionSheetMode:MHPhotoActionSheetModeImageList selectedPhotoModels:@[] completion:^(NSArray<UIImage *> * _Nonnull imageList, NSArray<MHPhotoSelectModel *> * _Nonnull selectPhotoModels) {
        [_imgVIew setImage:imageList[0]];
 
        
    }];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
    
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
