/********* CDVLeanPush.m Cordova Plugin Implementation *******/
#import <AVOSCloud/AVOSCloud.h>
#import "CDVLeanPush.h"

@implementation CDVLeanPush

- (void)subscribe:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* channel = [command.arguments objectAtIndex:0];

    NSLog(@"CDVLeanPush subscribe %@", channel);

    if (channel != nil && [channel length] > 0) {
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation addUniqueObject:channel forKey:@"channels"];
        [currentInstallation saveInBackground];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)unsubscribe:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* channel = [command.arguments objectAtIndex:0];

    NSLog(@"CDVLeanPush unsubscribe %@", channel);

    if (channel != nil && [channel length] > 0) {
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation removeObject:channel forKey:@"channels"];
        [currentInstallation saveInBackground];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)clearSubscription:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;

    NSLog(@"CDVLeanPush clearSubscription");

    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setObject:[[NSArray alloc] init] forKey:@"channels"];
    [currentInstallation saveInBackground];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)getInstallation:(CDVInvokedUrlCommand *)command
{
  CDVPluginResult* pluginResult = nil;

  NSLog(@"CDVLeanPush getInstallation");

  AVInstallation *currentInstallation = [AVInstallation currentInstallation];
  if(currentInstallation != nil && currentInstallation.deviceToken != nil) {
    NSLog(@"device token: %@", currentInstallation.deviceToken);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"ios,%@", currentInstallation.deviceToken]];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to get Installation."];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void)onNotificationReceived:(CDVInvokedUrlCommand *)command
{
    self.callback = [command.arguments objectAtIndex:0];
//    NSMutableDictionary* options = [command.arguments objectAtIndex:0];
//    self.callback = [options objectForKey:@"ecb"];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onMessage Success"];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}


-(void)parseDictionary:(NSDictionary *)inDictionary intoJSON:(NSMutableString *)jsonString
{
    NSArray         *keys = [inDictionary allKeys];
    NSString        *key;

    for (key in keys)
    {
        id thisObject = [inDictionary objectForKey:key];

        if ([thisObject isKindOfClass:[NSDictionary class]])
            [self parseDictionary:thisObject intoJSON:jsonString];
        else if ([thisObject isKindOfClass:[NSString class]])
            [jsonString appendFormat:@"\"%@\":\"%@\",",
             key,
             [[[[inDictionary objectForKey:key]
                stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
               stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
              stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
        else {
            [jsonString appendFormat:@"\"%@\":\"%@\",", key, [inDictionary objectForKey:key]];
        }
    }

}


- (NSString *)toJsonString:(NSDictionary *)dict;
{
    NSMutableString *jsonStr = [NSMutableString stringWithString:@"{"];
    [self parseDictionary:dict intoJSON:jsonStr];
    [jsonStr appendString:@"}"];
    return jsonStr;
}

- (void) sendJson:(NSDictionary *)command statusIs:(NSString *)status
{
        NSMutableString *jsonStr = [NSMutableString stringWithString:@"{"];
        [self parseDictionary:command intoJSON:jsonStr];
        if ([jsonStr length] > 0) {
            jsonStr = [NSMutableString stringWithString:[jsonStr substringToIndex:[jsonStr length] - 1]];
        }
        [jsonStr appendString:@"}"];

//    NSString * jsonStr = [NSString stringWithFormat:@"%@", command];

    if (self.callback) {
        NSString * jsCallBack = [NSString stringWithFormat:@"%@(%@,'%@');", self.callback,jsonStr,status];
//        NSLog(jsCallBack) ;
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    }else{
        self.cacheResult = jsonStr;
    }
}

- (void) getCacheResult:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;

    NSLog(@"CDVLeanPush getCacheResult = %@", self.cacheResult);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:self.cacheResult];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    self.cacheResult = NULL;

}
@end
