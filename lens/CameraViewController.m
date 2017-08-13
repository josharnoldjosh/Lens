//
//  CameraViewController.m
//
//  Created by Josh Arnold on 16/02/17.
//

#import "CameraViewController.h"
@import AVFoundation;
#import "WCGraintCircleLayer.h"
#import "ResultView.h"

@interface CameraViewController ()
@end

@implementation CameraViewController {
    AVCaptureStillImageOutput *output;
    AVCaptureSession * session;
    UIBarButtonItem *menu;
    UIView *crosshair;
    UIView *crosshair2;
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer setCornerRadius:12];
    [self.view setClipsToBounds:YES];
    [self setTitle:@"SkinLens"];
    
    [self setupCamera];
    
    menu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = menu;
    
    UIColor *mainBlue = [UIColor colorWithRed:0.1 green:0.35 blue:1 alpha:1];
    
    int btnHeight = 70;
    CGRect rect = CGRectMake(16, self.view.frame.size.height - btnHeight - 16, self.view.frame.size.width-32, btnHeight);
    UIButton *takePhoto = [[UIButton alloc]initWithFrame:rect];
    [takePhoto setTitle:@"Begin Scan" forState:UIControlStateNormal];
    [takePhoto.titleLabel setFont:[UIFont fontWithName:[takePhoto.titleLabel.font fontName] size:27]];
    [takePhoto setBackgroundColor:mainBlue];
    [takePhoto.layer setCornerRadius:7];
    [takePhoto setClipsToBounds:YES];
    [takePhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [takePhoto setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [takePhoto addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhoto];
    
    
    
    CGRect crosshairFrame = CGRectMake(0, 0, 80, 80);
    crosshair = [[UIView alloc]initWithFrame:crosshairFrame];
    //    [[crosshair layer]setBorderWidth:2];
    //    [[crosshair layer]setBorderColor:[[UIColor whiteColor]CGColor]];
    //    [[crosshair layer]setCornerRadius:40];
    [crosshair setCenter:[self.view center]];
    
    WCGraintCircleLayer *inner = [[WCGraintCircleLayer alloc]initGraintCircleWithBounds:crosshairFrame Position:CGPointMake(40, 40) FromColor:[UIColor whiteColor] ToColor:[UIColor colorWithWhite:1 alpha:0.4] LineWidth:3];
    [crosshair.layer addSublayer:inner];
    
    [self.view addSubview:crosshair];
    
    crosshair2 = [[UIView alloc]initWithFrame:crosshairFrame];
    //    [[crosshair layer]setBorderWidth:2];
    //    [[crosshair layer]setBorderColor:[[UIColor whiteColor]CGColor]];
    //    [[crosshair layer]setCornerRadius:40];
    [crosshair2 setCenter:[self.view center]];
    
    CGRect outerFrame = CGRectMake(0, 0, 104, 104);
    WCGraintCircleLayer *outer = [[WCGraintCircleLayer alloc]initGraintCircleWithBounds:outerFrame Position:CGPointMake(40, 40) FromColor:[UIColor colorWithWhite:1 alpha:0.4] ToColor:[UIColor whiteColor] LineWidth:3];
    [crosshair2.layer addSublayer:outer];
    
    [self.view addSubview:crosshair2];
    
    UIView *bigCircle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
    [bigCircle setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [[bigCircle layer]setCornerRadius:3];
    [self.view addSubview:bigCircle];
    bigCircle.center = self.view.center;
    
    [self startSpin];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

BOOL animating;

- (void)spinWithOptions:(UIViewAnimationOptions)options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration:0.35
                          delay:0
                        options:options
                     animations:^{
                         crosshair.transform = CGAffineTransformRotate(crosshair.transform, M_PI / 2);
                         crosshair2.transform = CGAffineTransformRotate(crosshair2.transform, M_PI / 4);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
    
}
- (void)startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}
- (void)stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}
- (void)focusCrossHairs {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGAffineTransform t = CGAffineTransformMakeScale(0.75, 0.75);
                         t = CGAffineTransformTranslate(t, 0, 0);
                         crosshair.transform = t;
                         
                         CGAffineTransform t2 = CGAffineTransformMakeScale(1.15, 1.15);
                         t2 = CGAffineTransformTranslate(t2, 0, 0);
                         crosshair2.transform = t2;
                         
                         crosshair.alpha = 0;
                         crosshair2.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self takeActualPhoto];
                         }
                     }];
}

- (void)unfocusCrossHairs {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
                         t = CGAffineTransformTranslate(t, 0, 0);
                         crosshair.transform = t;
                         
                         CGAffineTransform t2 = CGAffineTransformMakeScale(1, 1);
                         t2 = CGAffineTransformTranslate(t2, 0, 0);
                         crosshair2.transform = t2;
                         
                         crosshair.alpha = 1;
                         crosshair2.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
}

-(void)showMenu {
    
}

- (void)setupCamera {
    // Do any additional setup after loading the view.
    
    //Capture Session
    session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    
    //Add device
    AVCaptureDevice *device =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasFlash]){
        
        [device lockForConfiguration:nil];
        
        [device setFlashMode:AVCaptureFlashModeOff];
        
        [device unlockForConfiguration];
    }else {
        
    }
    
    //Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!input)
    {
        NSLog(@"No Input");
    }
    
    [session addInput:input];
    
    //Output
    
    output = [[AVCaptureStillImageOutput alloc] init];
    [session addOutput:output];
    
    //Preview Layer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    UIView *myView = self.view;
    previewLayer.frame = myView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    //Start capture session
    [session startRunning];
    
}
- (void)takePhoto {
    
    [self focusCrossHairs];
    
}
-(void)takeActualPhoto {
    AVCaptureConnection *conn = [[output connections]firstObject];
    
    [output captureStillImageAsynchronouslyFromConnection:conn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        [self processImage:image];
        
    }];
}

-(void)processImage:(UIImage*)image {
    
    CGSize size = CGSizeMake(400, 400);
    UIImage *crop = [self imageByCroppingImage:image toSize:size];
    
    [self useImage:crop];
    
    //    [self stopSpin];
    [self unfocusCrossHairs];
    //    [self startSpin];
}
- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return cropped;
}

-(void)showAlert:(NSString *)string {
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Results" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Resolving UIAlert Action for tapping OK Button");
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)useImage:(UIImage *)image {
    // This uses the neural network to scan an image
    NSString *text = [self analyseImage:image];
    
    text = [text stringByReplacingOccurrencesOfString:@"0 " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"1 " withString:@""];
    
    ResultView *view = [[ResultView alloc]initWithView:self.view :text :image];
    [view setAlwaysBounceVertical:YES];
    [view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [view.mainView setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height*9)];
    [view setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:10 initialSpringVelocity:17 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [view setFrame:self.view.bounds];
        [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    //    [self showAlert:text];
    [self.view addSubview:view];
    
}

@end
