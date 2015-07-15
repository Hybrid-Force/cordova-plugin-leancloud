var exec = require('cordova/exec');

module.exports = {
    getInstallation: function(success, error) {
        console.log('getInstallation');
        exec(function(info) {
            var a = info.split(',');
            success({
                'deviceType': a[0],
                installationId: a[1],
                'deviceToken': a[1]
            });
        }, error, "LeanPush", "getInstallation", []);
    },
    subscribe: function(channel, success, error) {
        console.log('subscribe', channel);
        exec(success, error, "LeanPush", "subscribe", [channel]);
    },

    unsubscribe: function(channel, success, error) {
        console.log('unsubscribe', channel);
        exec(success, error, "LeanPush", "unsubscribe", [channel]);
    },

    clearSubscription: function(success, error) {
        console.log('clearSubscription');
        exec(success, error, "LeanPush", "clearSubscription", []);
    },
    init: function(fun) {
        console.log('LeanPush Initialization');
        window.LeanPush.onNotificationReceived(fun || function(notice) {});

        window.LeanPush.init.__cb = function(x, status) {
            try {
                var notice;
                if (typeof x == 'string') {
                    notice = JSON.parse(x) || {};
                } else {
                    notice = x;
                }
            } catch (e) {
                notice = notice || {};                
                notice.error = e;
            }
            notice.prevAppState = status || 'closed';
            console.log('leancloud:notificationReceived', notice);
            if (notice) {
                if (typeof angular != 'undefined') {
                    var $body = angular.element(document.body);
                    $body.scope().$root.$emit('leancloud:notificationReceived', notice);
                }
                window.LeanPush.onNotificationReceived._fun(notice);
            }
        };
        cordova.exec(window.LeanPush.init.__cb, null, "LeanPush", "getCacheResult", []);
        cordova.exec(null, null, "LeanPush", "onNotificationReceived", ['window.LeanPush.init.__cb']);

    },
    onNotificationReceived: function(f) {
        window.LeanPush.onNotificationReceived._fun = f;
    }
};
