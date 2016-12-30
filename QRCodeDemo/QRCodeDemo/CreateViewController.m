//
//  CreateViewController.m
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/30.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "CreateViewController.h"
#import "QRCodeGenerate.h"
@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

        self.imageView.image = [QRCodeGenerate generateQRCode:@"www.baidu.com" size:CGSizeZero withIcon:nil];

        self.imageView1.image = [QRCodeGenerate generateBarCode:@"925153711389" size:CGSizeZero];
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
