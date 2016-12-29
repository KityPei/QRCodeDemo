//
//  ViewController.m
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/28.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeGenerate.h"
#import "QRCodeScanViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *qrCodeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
    qrCodeImageV.center = CGPointMake(self.view.bounds.size.width/2, 200);
    qrCodeImageV.image = [QRCodeGenerate generateQRCode:@"www.baidu.com" size:CGSizeZero withIcon:nil];
    [self.view addSubview:qrCodeImageV];
    
    
    UIImageView *barCodeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 300, 100)];
    barCodeImageV.center = CGPointMake(self.view.bounds.size.width/2, 450);
    barCodeImageV.image = [QRCodeGenerate generateBarCode:@"925153711389" size:CGSizeZero];
    [self.view addSubview:barCodeImageV];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
