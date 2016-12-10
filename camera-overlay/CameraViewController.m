#import "CameraViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCameraView];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.view.userInteractionEnabled = NO;
    [self.view.layer addSublayer:self.captureLayer];
}

- (void)viewDidLayoutSubviews
{
    CGRect bounds=self.captureLayer.bounds;
    self.captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureLayer.bounds=bounds;
    self.captureLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        [self updateCameraRotation];
        //self.captureLayer.frame = self.view.bounds;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCameraView{
    
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (camera == nil) return;
    self.captureDevice = camera;
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:nil];
    [self.captureSession addInput:newVideoInput];
    
    self.captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.captureLayer.frame = self.view.bounds;
    self.captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.captureSession startRunning];
}

-(void) updateCameraRotation
{
    AVCaptureConnection *previewLayerConnection=self.captureLayer.connection;
    if ([previewLayerConnection isVideoOrientationSupported])
    {
        [previewLayerConnection setVideoOrientation:[self videoOrientationFromCurrentViewOrientation]];
    }
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentViewOrientation {
    AVCaptureVideoOrientation orientation;
    
    switch ([[UIApplication sharedApplication] statusBarOrientation])
    {
        case UIInterfaceOrientationPortrait:
        {
            orientation = AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            orientation = AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            orientation = AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        }
        default:
        {
            orientation = AVCaptureVideoOrientationPortrait;
        }
    }
    
    return orientation;
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
