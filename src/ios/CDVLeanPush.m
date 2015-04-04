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

- (void)onViewStart:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* viewId = [command.arguments objectAtIndex:0];

    NSLog(@"CDVLeanPush onViewStart %@", viewId);

    if (viewId != nil && [viewId length] > 0) {
        [AVAnalytics beginLogPageView:viewId];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onViewEnd:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* viewId = [command.arguments objectAtIndex:0];

    NSLog(@"CDVLeanPush onViewEnd %@", viewId);

    if (viewId != nil && [viewId length] > 0) {
        [AVAnalytics endLogPageView:viewId];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)event:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventId = [command argumentAtIndex:0 withDefault:nil];
    NSString* label = [command argumentAtIndex:1 withDefault:nil];

    NSLog(@"CDVLeanPush event %@ %@", eventId, label);

    if (eventId != nil && [eventId length] > 0) {
        [AVAnalytics event:eventId label:label];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onEventStart:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventId = [command argumentAtIndex:0 withDefault:nil];
    NSString* label = [command argumentAtIndex:1 withDefault:nil];

    NSLog(@"CDVLeanPush onEventStart %@ %@", eventId, label);

    if (eventId != nil && [eventId length] > 0) {
        [AVAnalytics beginEvent:eventId label:label];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onEventEnd:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventId = [command argumentAtIndex:0 withDefault:nil];
    NSString* label = [command argumentAtIndex:1 withDefault:nil];

    NSLog(@"CDVLeanPush onEventEnd %@ %@", eventId, label);

    if (eventId != nil && [eventId length] > 0) {
        [AVAnalytics endEvent:eventId label:label];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onKVEventStart:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventId = [command argumentAtIndex:0 withDefault:nil];
    NSString* keyName = [command argumentAtIndex:1 withDefault:nil];
    NSString* attr = [command argumentAtIndex:2 withDefault:nil];
    NSString* value = [command argumentAtIndex:3 withDefault:nil];

    NSLog(@"CDVLeanPush onKVEventStart %@ %@ {%@:%@}", eventId, keyName, attr, value);

    if (eventId != nil && [eventId length] > 0) {
        NSDictionary *attrs = [NSDictionary dictionaryWithObject:value forKey:attr];
        [AVAnalytics beginEvent:eventId primarykey:keyName attributes:attrs];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onKVEventEnd:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventId = [command argumentAtIndex:0 withDefault:nil];
    NSString* keyName = [command argumentAtIndex:1 withDefault:nil];

    NSLog(@"CDVLeanPush onKVEventEnd %@ %@", eventId, keyName);

    if (eventId != nil && [eventId length] > 0) {
        [AVAnalytics endEvent:eventId primarykey:keyName];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
