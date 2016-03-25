#import "AppDelegate+LeanPush.h"
#import "CDVLeanPush.h"
#import <AVOSCloud/AVOSCloud.h>
#import <objc/runtime.h>

@implementation AppDelegate (CDVLean)

void swizzleMethod(Class c, SEL originalSelector)
{
    NSString *original = NSStringFromSelector(originalSelector);

    SEL swizzledSelector = NSSelectorFromString([@"swizzled_" stringByAppendingString:original]);
    SEL noopSelector = NSSelectorFromString([@"noop_" stringByAppendingString:original]);

    Method originalMethod, swizzledMethod, noop;
    originalMethod = class_getInstanceMethod(c, originalSelector);
    swizzledMethod = class_getInstanceMethod(c, swizzledSelector);
    noop = class_getInstanceMethod(c, noopSelector);

    BOOL didAddMethod = class_addMethod(c,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));

    if (didAddMethod)
    {
        class_replaceMethod(c,
                            swizzledSelector,
                            method_getImplementation(noop),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];

        swizzleMethod(cls, @selector(application:didFinishLaunchingWithOptions:));
        swizzleMethod(cls, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
        swizzleMethod(cls, @selector(application:didFailToRegisterForRemoteNotificationsWithError:));
        swizzleMethod(cls, @selector(application:didReceiveRemoteNotification:));
        swizzleMethod(cls, @selector(applicationDidBecomeActive:));
    });
}

- (BOOL)swizzled_application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Original application is exchanged with swizzled_application
    // So, when calling swizzled_application, we are actually calling the original application method
    // similar with subclass calling super method. Neat!
    BOOL ret = [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];

    if (ret) {
        // 1. Initialize LeanCloud
        // 2. Send analysis info
        // 3. Register remote notification
        NSString *appId = [self.viewController.settings objectForKey:PROP_KEY_LEANCLOUD_APP_ID];
        NSString *appKey = [self.viewController.settings objectForKey:PROP_KEY_LEANCLOUD_APP_KEY];
        if (appId && appKey) {
            // init
            [AVOSCloud setApplicationId:appId clientKey:appKey];

            // analysis
            if (application.applicationState != UIApplicationStateBackground) {
                // Track an app open here if we launch with a push, unless
                // "content_available" was used to trigger a background push (introduced
                // in iOS 7). In that case, we skip tracking here to avoid double
                // counting the app-open.
                BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
                BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
                BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
                if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
                }
            }

            // register remote notification
            if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]==NO) {
                [application registerForRemoteNotificationTypes:
                                UIRemoteNotificationTypeBadge |
                                UIRemoteNotificationTypeAlert |
                                UIRemoteNotificationTypeSound];
            } else {
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
                [application registerUserNotificationSettings:settings];
                [application registerForRemoteNotifications];
            }
        } else {
            NSLog(@"LeanCloud app ID/key not specified");
        }
    }
    NSDictionary *localNotif = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    if (localNotif)
    {
        CDVLeanPush *pushHandler = [self.viewController getCommandInstance:@"LeanPush"];
        [pushHandler sendJson:localNotif statusIs: @""];
    }

    return ret;
}

- (BOOL)noop_application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    return YES;
}

- (void)swizzled_applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    int num=application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
}

- (void)noop_applicationDidBecomeActive:(UIApplication *)application
{}


- (void)swizzled_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self swizzled_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

    NSLog(@"didRegister");
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setBadge:0];
    [currentInstallation saveInBackground];
}

- (void)noop_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{}


-(void)swizzled_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self swizzled_application:application didFailToRegisterForRemoteNotificationsWithError:error];

    [AVAnalytics event:@"Failed enable push notification" label:[error description]];
    NSLog(@"error=%@",[error description]);
}

-(void)noop_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{}


-(void)swizzled_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self swizzled_application:application didReceiveRemoteNotification:userInfo];
    CDVLeanPush *pushHandler = [self.viewController getCommandInstance:@"LeanPush"];

    if (application.applicationState == UIApplicationStateActive) {
        // foreground
        [pushHandler sendJson:userInfo statusIs:@"foreground"];
    } else {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [pushHandler sendJson:userInfo statusIs:@"background"];
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }

    int num = application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
}

-(void)noop_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{}

@end
