//
//  QRCodeScanViewController.h
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/28.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeScanViewControllerDelegate <NSObject>

- (void)QRCodeScanViewControllerDidGetCode:(NSString *)code;
- (void)QRCodeScanViewControllerDidGetCodeForImage:(NSString *)code;

@end



@interface QRCodeScanViewController : UIViewController

@property (weak, nonatomic) id <QRCodeScanViewControllerDelegate> delegate;

- (void)pauseScan;
- (void)continueScan;
- (void)choicePhoto;


+ (BOOL)isTurnOnLED;
+ (void)turnLEDChangeState:(BOOL)on;

@end
