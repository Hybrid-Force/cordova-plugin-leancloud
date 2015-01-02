#import <Cordova/CDV.h>

#define PROP_KEY_LEANCLOUD_APP_ID @"leancloud-appid"
#define PROP_KEY_LEANCLOUD_APP_KEY @"leancloud-appkey"

@interface CDVLeanPush:CDVPlugin

@property (nonatomic, strong) NSString *leancloudAppId;
@property (nonatomic, strong) NSString *leancloudAppKey;

- (void)subscribe:(CDVInvokedUrlCommand *)command;
- (void)unsubscribe:(CDVInvokedUrlCommand *)command;

@end