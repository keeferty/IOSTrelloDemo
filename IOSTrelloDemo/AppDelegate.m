//
//  AppDelegate.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "AppDelegate.h"
#import <AF2OAuth1Client.h>
#import <JSONModel.h>
#import "PWDataManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:24]}];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:kAFApplicationLaunchOptionsURLKey]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PWDataManager sharedInstance] save];
    });
}
@end
