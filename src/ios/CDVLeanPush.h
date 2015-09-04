#import <Cordova/CDV.h>

#define PROP_KEY_LEANCLOUD_APP_ID @"leancloud-appid"
#define PROP_KEY_LEANCLOUD_APP_KEY @"leancloud-appkey"

@interface CDVLeanPush:CDVPlugin

@property (nonatomic, strong) NSString *leancloudAppId;
@property (nonatomic, strong) NSString *leancloudAppKey;

@property (nonatomic, strong) NSString *cacheResult;
@property (nonatomic, strong) NSString *callback;

- (void)subscribe:(CDVInvokedUrlCommand *)command;
- (void)unsubscribe:(CDVInvokedUrlCommand *)command;
- (void)clearSubscription:(CDVInvokedUrlCommand *)command;
- (void)onNotificationReceived:(CDVInvokedUrlCommand *)command;
- (void)getInstallation:(CDVInvokedUrlCommand *)command;
- (void)getCacheResult:(CDVInvokedUrlCommand *)command;
- (void)sendJson:(NSDictionary *)command statusIs:(NSString *)status;


@end
