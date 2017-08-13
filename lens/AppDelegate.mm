// Copyright 2015 Josh Arnold

#import "AppDelegate.h"

#import "RunModelViewController.h"
#import "CameraViewController.h"
#import "MainNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CameraViewController *main = [[CameraViewController alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = main;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
