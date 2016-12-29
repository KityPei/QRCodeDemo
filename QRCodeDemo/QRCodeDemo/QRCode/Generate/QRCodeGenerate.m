//
//  QRCodeGenerate.m
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/28.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "QRCodeGenerate.h"

@implementation QRCodeGenerate

//  生成条形码

+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size {
    // 生成条形码
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];// 创建过滤器
    [filter setDefaults];// 恢复默认
    
    [filter setValue:data forKey:@"inputMessage"];// 给过滤器添加数据,通过kvo设置滤镜inputMessage数据
    barcodeImage = [filter outputImage];//  获取输出的条形码图片
    
    if (!barcodeImage) {
        NSLog(@"生成条形码失败！");
        return nil;
    }
    
    // 调整图片比例，消除模糊
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(320, 320.0 * barcodeImage.extent.size.height/barcodeImage.extent.size.width);
    } else {
        if (size.width > 3 * size.height) {
            size = CGSizeMake(size.width, size.width*barcodeImage.extent.size.height/barcodeImage.extent.size.width);
        } else {
            size = CGSizeMake(size.height/(barcodeImage.extent.size.height/barcodeImage.extent.size.width), size.height);
        }
    }
    
    CGFloat scaleX = size.width/barcodeImage.extent.size.width;
    CGFloat scaleY = size.height/barcodeImage.extent.size.height;
    barcodeImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];//按照比例缩放
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:barcodeImage fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return finalImage;
}

//  生成二维码
+ (UIImage *)generateQRCode:(NSString *)code size:(CGSize)size withIcon:(UIImage *)icon {
    //  生成二维码
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];// 创建过滤器
    [filter setDefaults];// 恢复默认
    [filter setValue:data forKey:@"inputMessage"];// 给过滤器添加数据,通过kvo设置滤镜inputMessage数据
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    qrcodeImage = [filter outputImage];//  获取输出的二维码图片
    
    if (!qrcodeImage) {
        NSLog(@"生成二维码失败");
        return nil;
    }
    
    // 调整图片比例，消除模糊
    if(CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(320., 320.0f*qrcodeImage.extent.size.height/qrcodeImage.extent.size.width);
    } else {
        size = CGSizeMake(MAX(size.width, size.height), MAX(size.width, size.height));
    }
    
    CGFloat scaleX = size.width / qrcodeImage.extent.size.width;
    CGFloat scaleY = size.height / qrcodeImage.extent.size.height;
    
    qrcodeImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];//按照比例缩放
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:qrcodeImage fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    
    if (icon) {
        float scaleForIcon = 3.0f / (7.0f*3+1.0f*2);
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:icon];
        
        imageV.frame = CGRectMake((size.width*(1-scaleForIcon))/2, (size.width*(1-scaleForIcon))/2, size.width*scaleForIcon, size.width*scaleForIcon);
        
        imageV.layer.cornerRadius = 5.0f;
        imageV.layer.masksToBounds = YES;
        imageV.layer.borderColor = [UIColor whiteColor].CGColor;
        imageV.layer.borderWidth = 3;
        
//        创建一个基于位图的上下文
//        size——同UIGraphicsBeginImageContext
//        opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
//        scale—–缩放因子
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0);
        [finalImage drawAtPoint:CGPointMake(0, 0)];//原始图片大小，只是绘制位置，左上原点
        
//        平移
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), (size.width*(1-scaleForIcon))/2, (size.width*(1-scaleForIcon))/2);
//        将平移后的图片导入到context中
        [imageV.layer renderInContext:UIGraphicsGetCurrentContext()];
//        平移
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -(size.width*(1-scaleForIcon))/2, -(size.width*(1-scaleForIcon))/2);
        
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return finalImage;
}

@end
