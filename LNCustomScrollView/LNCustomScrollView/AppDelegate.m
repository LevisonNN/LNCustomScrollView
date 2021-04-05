//
//  AppDelegate.m
//  LNCustomScrollView
//
//  Created by Levison on 5.4.21.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LNCustomScrollViewClock.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[LNCustomScrollViewClock shareInstance] startOrResume];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    MainViewController *mainController = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainController];
    nav.navigationBar.translucent = NO;
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}


@end
