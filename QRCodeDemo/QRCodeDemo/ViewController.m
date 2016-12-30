//
//  ViewController.m
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/28.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "ViewController.h"
#import "CreateViewController.h"
#import "ManageViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
//    
}


- (IBAction)createBtnClick:(id)sender {
    CreateViewController *vc = [[CreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)manageBtnClick:(id)sender {
    ManageViewController *vc = [[ManageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
