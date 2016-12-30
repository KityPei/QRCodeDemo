//
//  ManageViewController.m
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/30.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "ManageViewController.h"
#import "QRCodeScanViewController.h"
#import "ResultViewController.h"
@interface ManageViewController ()<QRCodeScanViewControllerDelegate>

@end

@implementation ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    vc.delegate = self;
    [self.view addSubview:vc.view];
    
    [vc continueScan];
}

- (void)QRCodeScanViewControllerDidGetCodeForImage:(NSString *)code {
    NSLog(@"==%@==",code);
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.result = code;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"QRCodeScanViewControllerDidGetCodeForImage");
}
- (void)QRCodeScanViewControllerDidGetCode:(NSString *)code {
    NSLog(@"==%@==",code);
    
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.result = code;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"QRCodeScanViewControllerDidGetCode");
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
