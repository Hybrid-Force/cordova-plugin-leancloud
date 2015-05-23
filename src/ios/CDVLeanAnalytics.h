#import <Cordova/CDV.h>

@interface CDVLeanAnalytics:CDVPlugin

- (void)onViewStart:(CDVInvokedUrlCommand *)command;
- (void)onViewEnd:(CDVInvokedUrlCommand *)command;
- (void)event:(CDVInvokedUrlCommand *)command;
- (void)onEventStart:(CDVInvokedUrlCommand *)command;
- (void)onEventEnd:(CDVInvokedUrlCommand *)command;
- (void)onKVEventStart:(CDVInvokedUrlCommand *)command;
- (void)onKVEventEnd:(CDVInvokedUrlCommand *)command;

@end