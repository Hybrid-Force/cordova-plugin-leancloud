var exec = require('cordova/exec');

module.exports = {
    coolMethod: function(arg0, success, error) {
        console.log('coolMethos');
        exec(success, error, "LeanPush", "coolMethod", [arg0]);
    }
};
