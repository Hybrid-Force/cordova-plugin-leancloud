/********* CDVLeanPush.m Cordova Plugin Implementation *******/

#import "CDVLeanPush.h"

@implementation CDVLeanPush


- (void)subscribe:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    NSLog(@"CDVLeanPush got the message %@", echo);

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)unsubscribe:(CDVInvokedUrlCommand*)command
{}

@end
