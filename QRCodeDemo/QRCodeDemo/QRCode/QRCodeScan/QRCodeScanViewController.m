//
//  QRCodeScanViewController.m
//  QRCodeDemo
//
//  Created by Kity_Pei on 2016/12/28.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>

static CGFloat const scanContent_Y = 6.0f;
static CGFloat const animation_Duration = 0.05;

@interface QRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) AVCaptureSession *session;//  二维码生成的绘画
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;//   预览图层

@end

@implementation QRCodeScanViewController {
    UIView *_loadingView;
    UIActivityIndicatorView *_loadingIndicView;
    UILabel *_loadingLabel;
    UIImageView *imageLine;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeTimer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect UIScreem = self.view.bounds;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((UIScreem.size.width-220)/2, (UIScreem.size.height-220)/2, 220, 220)];
    contentView.backgroundColor = [UIColor clearColor];
    UIImageView *imageEdge = [[UIImageView alloc] initWithFrame:contentView.bounds];
    imageEdge.image = [QRCodeScanViewController GMImageNamed:@"qrcode_rect_img"];
    
//    imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(6, (220-1)/2, 220-6*2, 1)];
    imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(6, 1, 220-6*2, 1)];
    imageLine.image = [QRCodeScanViewController GMImageNamed:@"qrcode_line_img"];
    [contentView addSubview:imageEdge];
    [contentView addSubview:imageLine];
    
    [self.view addSubview:contentView];
    
    
    //back
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreem.size.width, (UIScreem.size.height-220)/2)];
    viewTop.backgroundColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [self.view addSubview:viewTop];
    
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, (UIScreem.size.height-220)/2+220, UIScreem.size.width, (UIScreem.size.height-220)/2)];
    viewBottom.backgroundColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [self.view addSubview:viewBottom];
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, (UIScreem.size.height-220)/2, (UIScreem.size.width-220)/2, 220)];
    viewLeft.backgroundColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [self.view addSubview:viewLeft];
    
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake((UIScreem.size.width-220)/2+220, (UIScreem.size.height-220)/2, (UIScreem.size.width-220)/2, 220)];
    viewRight.backgroundColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [self.view addSubview:viewRight];
    
    _loadingView = [[UIView alloc] initWithFrame:UIScreem];
    _loadingView.backgroundColor = [UIColor blackColor];
    _loadingView.hidden = YES;
    
    _loadingIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loadingIndicView.frame = CGRectMake((_loadingView.bounds.size.width-37)/2, (_loadingView.bounds.size.height-37)/2, 37, 37);
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((_loadingView.bounds.size.width-100)/2, (_loadingView.bounds.size.height-37)/2+37, 100, 20)];
    _loadingLabel.font = [UIFont systemFontOfSize:14];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.text = @"加载中";
    
    [_loadingView addSubview:_loadingIndicView];
    [_loadingView addSubview:_loadingLabel];
    [_loadingIndicView stopAnimating];
    
    
    [self.view addSubview:_loadingView];
    
    //扫描二维码
    [self readQRCode];
}

#pragma mark -
#pragma mark --扫描二维码--
- (void)readQRCode {
    //建立拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        session.sessionPreset = AVCaptureSessionPreset1920x1080;//采集质量
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//获取摄像头设备
    NSError *error = nil;
    //  设置绘画输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头----%@",error.localizedDescription);
        return;
    }
    [session addInput:input];
    
    //  设置绘画输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    CGRect UIScreem = self.view.bounds;
    CGRect cropRect = CGRectMake((UIScreem.size.width-220)/2, (UIScreem.size.height-220)/2, 220, 220);
    CGFloat p1 = UIScreem.size.height/UIScreem.size.width;
    CGFloat p2 = 1920.0f/1080;
    
    if (p1 < p2) {
        CGFloat fixHeight = UIScreem.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - UIScreem.size.height)/2;
        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                           cropRect.origin.x/UIScreem.size.width,
                                           cropRect.size.height/fixHeight,
                                           cropRect.size.width/UIScreem.size.width);
    } else {
        CGFloat fixWidth = UIScreem.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - UIScreem.size.width)/2;
        output.rectOfInterest = CGRectMake(cropRect.origin.y/UIScreem.size.height,
                                           (cropRect.origin.x + fixPadding)/fixWidth,
                                           cropRect.size.height/UIScreem.size.height,
                                           cropRect.size.width/fixWidth);
    }
    
    
    [session addOutput:output];

    //  提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];//条形码+二维码
    
    
    //  设置预览图层（用来让用户能够看到扫描结果）
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    //  设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //  设置preview图层的大小
    [preview setFrame:self.view.layer.bounds];
    //  将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    
    self.previewLayer = preview;
    self.session = session;
    // 启动绘画
    [session startRunning];
    
    self.timer =[NSTimer scheduledTimerWithTimeInterval:animation_Duration target:self selector:@selector(animation_line_action) userInfo:nil repeats:YES];
}

#pragma mark -
#pragma mark --AVCaptureMetadataOutputObjectsDelegate--
//  此方法是在识别到QRCode，并且完成转换
//  如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    //  因为会频繁扫描，调用代理方法 如果扫描完成，停止会话
    [self.session stopRunning];
    
    //  删除预览图层
    [self.previewLayer removeFromSuperlayer];
    [self removeTimer];
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (obj) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeScanViewControllerDidGetCode:)]) {
                [self.delegate QRCodeScanViewControllerDidGetCode:obj.stringValue];
            }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

#pragma mark -
#pragma mark --UIImagePickerControllerDelegate--
//选中图片的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:NO completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];;
        NSData *imageData = UIImagePNGRepresentation(image);
        CIImage *ciImage = [CIImage imageWithData:imageData];
        
        //创建探测器
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
        NSArray *feature = [detector featuresInImage:ciImage];
        
        //取出探测到的数据
        NSString *content;
        for (CIQRCodeFeature *result in feature) {
            content = result.messageString;
            if (content) {
                break;
            }
        }
        
        //扫描 结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeScanViewControllerDidGetCodeForImage:)]) {
            [self.delegate QRCodeScanViewControllerDidGetCodeForImage:content];
        }
        if (content && content.length > 0) {
            //扫描成功 结束
            // 会频繁的扫描，调用代理方法  如果扫描完成，停止会话
            [self.session stopRunning];
            // 删除预览图层
            [self.previewLayer removeFromSuperlayer];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else{
            [self.session startRunning];
            _loadingView.hidden = YES;
            [_loadingIndicView stopAnimating];
        }
    }];
}

#pragma mark -
#pragma mark --private method--
- (void)pauseScan {
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)continueScan {
    if (self.session) {
        [self.session startRunning];
    }
    _loadingView.hidden = YES;
    [_loadingIndicView stopAnimating];
}

- (void)showLoading {
    [self.session stopRunning];
    [self.view bringSubviewToFront:_loadingView];
    _loadingView.hidden = NO;
    [_loadingIndicView startAnimating];
}

- (void)choicePhoto{
    //调用相册
    if (![self checkPhotoPermissions]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"照片权限未开启" message:[NSString stringWithFormat:@"请进入系统【设置】>【隐私】>【%@】中打开开关,并允许%@使用%@服务",@"照片",[QRCodeScanViewController getAppDisplayName],@"照片"] preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开系统app定位开关
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
        
        return;
    }
    
    UIImagePickerController *imageViewController = [[UIImagePickerController alloc] init];
    [imageViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imageViewController.navigationBar setBarStyle:UIBarStyleBlack];
    [imageViewController setDelegate:self];
    [imageViewController setAllowsEditing:NO];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imageViewController animated:YES completion:nil];
    
    [self showLoading];
}

//  获取相册权限判断
- (BOOL)checkPhotoPermissions{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 9.) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return NO;
        }else{
            //已授权 或 未询问
            return YES;
        }
    }else{
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
            //无权限
            return NO;
        }else{
            //已授权 或 未询问
            return YES;
        }
    }
}

//  定时器相关
- (void)animation_line_action {
    __block CGRect frame = imageLine.frame;
    
    static BOOL flag = YES;
    
    if (flag) {
        flag = NO;
        [UIView animateWithDuration:animation_Duration animations:^{
            frame.origin.y += 5;
            imageLine.frame = frame;
        } completion:nil];
    } else {
        if (imageLine.frame.origin.y >= scanContent_Y+5) {
            CGFloat scanContent_MaxY = 210;
            if (imageLine.frame.origin.y >= scanContent_MaxY) {
                frame.origin.y = scanContent_Y;
                imageLine.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:animation_Duration animations:^{
                    frame.origin.y += 5;
                    imageLine.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    [imageLine removeFromSuperview];
    imageLine = nil;
}

#pragma mark -
#pragma mark --闪光灯相关--
+ (BOOL)isTurnOnLED {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        if (device.torchMode == AVCaptureTorchModeOn) {
            return YES;
        }
    }
    return NO;
}

+ (void)turnLEDChangeState:(BOOL)on {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        if (on) {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];
        } else {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

#pragma mark -
#pragma mark --Tool--
+ (UIImage *)GMImageNamed:(NSString *)name{
    UIImage *iimage = [UIImage imageNamed:name];
    if (iimage) {
        return iimage;
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ADQRCode" ofType:@"bundle"]];
    NSString *imagePath = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}
+ (NSString *)getAppDisplayName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
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
