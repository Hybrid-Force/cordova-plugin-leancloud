var exec = require('cordova/exec');

module.exports = {
    getInstallation: function(success, error) {
        console.log('getInstallation');
        exec(success, error, "LeanPush", "getInstallation", []);
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
    }
};
