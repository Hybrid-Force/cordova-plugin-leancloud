function ___cordovaLeanPushCallback___(x) {
    var notice;
    if(typeof x == 'string'){
        notice = JSON.parse(x);
    }
    else {
        notice = x;
    }
    if (notice) {
        var $body = angular.element(document.body);
        $body.scope().$root.$emit('leancloud:notificationRecieved', notice);
    }
}

function lpushInit() {
    if (typeof angular == 'undefined') {
        throw new Error("angular is not defined!");
    }
    if(typeof cordova == 'undefined'){
        throw new Error("cordova is not defined!");
    }
    cordova.exec(___cordovaLeanPushCallback___, null, "LeanPush", "getCacheResult", []);
    cordova.exec(null, null, "LeanPush", "onMessage", [___cordovaLeanPushCallback___.name]);
}
