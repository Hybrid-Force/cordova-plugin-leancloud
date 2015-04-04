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

    onViewStart: function(viewId, success, error) {
        console.log('onViewStart', viewId);
        exec(success, error, "LeanPush", "onViewStart", [viewId]);
    },

    onViewEnd: function(viewId, success, error) {
        console.log('onViewEnd', viewId);
        exec(success, error, "LeanPush", "onViewEnd", [viewId]);
    },

    event: function(eventId, label, success, error) {
        console.log('event', eventId, label);
        exec(success, error, "LeanPush", "event", [eventId, label]);
    },

    onEventStart: function(eventId, label, success, error) {
        console.log('onEventStart', eventId, label);
        exec(success, error, "LeanPush", "onEventStart", [eventId, label]);
    },

    onEventEnd: function(eventId, label, success, error) {
        console.log('onEventEnd', eventId, label);
        exec(success, error, "LeanPush", "onEventEnd", [eventId, label]);
    },

    onKVEventStart: function(eventId, key, attr, value, success, error) {
        console.log('onKVEventStart', eventId, key, attr, value);
        exec(success, error, "LeanPush", "onKVEventStart", [eventId, key, attr, value]);
    },

    onKVEventEnd: function(eventId, key, success, error) {
        console.log('onKVEventEnd', eventId, key);
        exec(success, error, "LeanPush", "onKVEventEnd", [eventId, key]);
    }
};
