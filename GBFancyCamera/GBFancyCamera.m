//
//  GBFancyCamera.m
//  GBFancyCamera
//
//  Created by Luka Mirosevic on 29/08/2013.
//  Copyright (c) 2013 Goonbee. All rights reserved.
//

#import "GBFancyCamera.h"

#import "GPUImage.h"

static CGFloat const kBottomBarHeight =                             80;
static CGFloat const kBottomBarBackroundHeight =                    0;
static CGFloat const kBarArrowImageBottomCenterOffset =             0;
static CGFloat const kBarButtonsBottomCenterOffset =                0;
static CGFloat const kMainButtonBottomCenterOffset =                0;
static CGFloat const kMainButtonAcceptModeRightCenterOffset =       0;
static CGFloat const kRetakeButtonRightCenterOffset =               0;
static CGFloat const kCancelButtonLeftCenterOffset =                0;
static CGFloat const kCameraRollButtonRightCenterOffset =           0;
static UIEdgeInsets const kScrollViewPadding =                      (UIEdgeInsets){0, 0, 0, 0};

static CGSize const kThumbnailBoxSize =                             (CGSize){0, 0};
static CGFloat const kThumbnailBoxTopMargin =                       0;
static CGFloat const kThumbnailBoxSideMargin =                      0;

static CGSize const kThumbnailImageSize =                           (CGSize){0, 0};
static CGFloat const kThumbnailImageTopMargin =                     0;
static CGFloat const kThumbnailImageCornerRadius =                  0;


typedef enum {
    GBFancyCameraStateCapturing,
    GBFancyCameraStateEditing
} GBFancyCameraState;

@interface GBFancyCamera ()

@property (assign, nonatomic) GBFancyCameraState                    state;

@property (strong, nonatomic) GPUImageStillCamera                   *stillCamera;

@property (strong, nonatomic) UIView                                *barContainerView;
@property (strong, nonatomic) UIImageView                           *barbackgroundImageView;
@property (strong, nonatomic) UIImageView                           *barArrowImageView;

@property (strong, nonatomic) UIButton                              *mainButton;
@property (strong, nonatomic) UIButton                              *cancelButton;
@property (strong, nonatomic) UIButton                              *cameraRollButton;
@property (strong, nonatomic) UIButton                              *retakeButton;

@property (strong, nonatomic) UIView                                *filtersContainerView;
@property (strong, nonatomic) UIImageView                           *meshTrayImageView;
@property (strong, nonatomic) UIScrollView                          *filtersScrollView;

@end

@implementation GBFancyCamera

//foo tapping a filter thumb should scroll to him

#pragma mark - Memory

+(GBFancyCamera *)sharedCamera {
    static GBFancyCamera *_sharedCamera;
    @synchronized(self) {
        if (!_sharedCamera) {
            _sharedCamera = [self new];
        }
    }
    
    return _sharedCamera;
}

#pragma mark - CA

-(void)setState:(GBFancyCameraState)state {
    [self _transitionToState:state animated:NO];
}

#pragma mark - Life

//foo needs to handle case where there is no camera (e.g. simulator)

-(void)viewDidLoad {
    [super viewDidLoad];

    //full screen stuff
    self.view.backgroundColor = [UIColor blackColor];
    self.wantsFullScreenLayout = YES;
    
    //set up camera stuff
    self.stillCamera = [[GPUImageStillCamera alloc] init];//perhaps init this sooner so loading is faster
    GPUImageSepiaFilter *sepia = [GPUImageSepiaFilter new];
//    GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc] init];
    GPUImageView *targetView = [[GPUImageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                              self.view.bounds.origin.y,
                                                                              self.view.bounds.size.width,
                                                                              self.view.bounds.size.height - kBottomBarHeight)];
    targetView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    targetView.autoresizesSubviews = YES;
    
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    targetView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

    [self.stillCamera addTarget:sepia];
    [sepia addTarget:targetView];
//    [self.stillCamera addTarget:filter];
//    [filter addTarget:targetView];
    [self.view addSubview:targetView];
    
    //add controls
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    //turn on the camera
    [self.stillCamera startCameraCapture];
    
    //add the shutter on top and make it ready
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //animate the shutter away
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //show the status bar, but only if it was previously shown
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //turn off camera capture
    
    //get rid of the shutter (idempotently)
}

//need to be able to handle different orientation, always, even if the app only claims to only support a single orientation

#pragma mark - Util

-(void)_capturePhoto {
    
}

-(void)_transitionToState:(GBFancyCameraState)state animated:(BOOL)animated {
    if (_state != state) {
        _state = state;//foo maybe do this at the bottom
    }
    
    
}

#pragma mark - Actions

@end
