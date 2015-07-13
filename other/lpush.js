function ___cordovaLeanPushCallback___(x) {
    var notice;
    if (typeof x == 'string') {
        notice = JSON.parse(x);
    } else {
        notice = x;
    }
    if (notice) {
        if (typeof angular != 'undefined') {
            var $body = angular.element(document.body);
            $body.scope().$root.$emit('leancloud:notificationRecieved', notice);
        }
        window.LeanPush.onMessage._fun(notice);
    }
}

window.LeanPush.init = function (fun){
    if (typeof cordova == 'undefined') {
        throw new Error("cordova is not defined!");
    }
    window.LeanPush.onMessage = function(f) {
        window.LeanPush.onMessage._fun = f;
    };
    window.LeanPush.onMessage(fun || function(notice){
        console.log('leancloud;notificationReceived', notice);
    });
    cordova.exec(___cordovaLeanPushCallback___, null, "LeanPush", "getCacheResult", []);
    cordova.exec(null, null, "LeanPush", "onMessage", [___cordovaLeanPushCallback___.name]);
};
