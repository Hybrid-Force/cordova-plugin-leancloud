var exec = require('cordova/exec');

module.exports = {
    onViewStart: function(viewId, success, error) {
        console.log('onViewStart', viewId);
        exec(success, error, "LeanAnalytics", "onViewStart", [viewId]);
    },

    onViewEnd: function(viewId, success, error) {
        console.log('onViewEnd', viewId);
        exec(success, error, "LeanAnalytics", "onViewEnd", [viewId]);
    },

    event: function(eventId, label, success, error) {
        console.log('event', eventId, label);
        exec(success, error, "LeanAnalytics", "event", [eventId, label]);
    },

    onEventStart: function(eventId, label, success, error) {
        console.log('onEventStart', eventId, label);
        exec(success, error, "LeanAnalytics", "onEventStart", [eventId, label]);
    },

    onEventEnd: function(eventId, label, success, error) {
        console.log('onEventEnd', eventId, label);
        exec(success, error, "LeanAnalytics", "onEventEnd", [eventId, label]);
    },

    onKVEventStart: function(eventId, key, attr, value, success, error) {
        console.log('onKVEventStart', eventId, key, attr, value);
        exec(success, error, "LeanAnalytics", "onKVEventStart", [eventId, key, attr, value]);
    },

    onKVEventEnd: function(eventId, key, success, error) {
        console.log('onKVEventEnd', eventId, key);
        exec(success, error, "LeanAnalytics", "onKVEventEnd", [eventId, key]);
    }
};
