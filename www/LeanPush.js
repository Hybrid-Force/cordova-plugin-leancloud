var exec = require('cordova/exec');

module.exports = {
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
