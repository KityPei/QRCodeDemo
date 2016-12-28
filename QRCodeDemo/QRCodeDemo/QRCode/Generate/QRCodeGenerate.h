//
//  QRCodeGenerate.h
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/28.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QRCodeGenerate : NSObject

/**
 *  生成条形码
 *
 *  @param size 可以为CGRectZero
 *  @return 尺寸长宽比固定 (约3.2/1)
 */
+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size;

/**
 *  生成二维码
 *
 *  @param size 可以为CGRectZero
 *  @param icon logo图标 default nil
 *  @return 尺寸长宽比固定 (1/1)
 */
+ (UIImage *)generateQRCode:(NSString *)code size:(CGSize)size withIcon:(UIImage *)icon;

@end
