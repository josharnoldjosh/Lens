//
//  MainNavigationController.m
//
//  Created by Josh Arnold on 1/03/17.
//

#import "MainNavigationController.h"
#import "CameraViewController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController {
    CameraViewController *vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    vc = [[CameraViewController alloc]init];
    NSArray *array = [[NSArray alloc]initWithObjects:vc, nil];
    [self setViewControllers:array];
}

@end
