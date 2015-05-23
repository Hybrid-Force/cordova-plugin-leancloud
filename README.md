cordova-plugin-lean-push
========================

Cordova plugin for LeanCloud push notification

## Installation
    
    cordova plugin add git@github.com:Hybrid-Force/cordova-plugin-leancloud.git --variable LEAN_APP_ID=<YOUR_LEANCOULD_APP_ID> --variable LEAN_APP_KEY=<YOUR_LEANCOULD_APP_KEY>

## Android Quirk
The LeanCloud push service need to be initialized in Application::onCreate, otherwise, the app might crash when opening via push notification when the app is not running in foreground. To fix this, add an application where we can initialize the push service.

1. Edit `platforms/android/src/com/sum/cordova/leancloud/LeanApplication.java`, replace `<%MAINACTIVITY%>`, `<%APPID%>` and `<%APPKEY%>`.

2. Edit `platforms/android/AndroidManifest.xml`, add `android:name="com.sum.cordova.leancloud.LeanApplication"` to application element

These can be easily done with gulp, for example:

    var xeditor = require('gulp-xml-editor');
    var replace = require('gulp-replace');
    var config = require('./package.json');

    gulp.task('android-manifest', function() {
        return gulp.src("platforms/android/AndroidManifest.xml")
            .pipe(xeditor([
                {
                    path: '/manifest/application',
                    attr: {'android:name': 'com.sum.cordova.leancloud.LeanApplication'}
                }], {'android': 'http://schemas.android.com/apk/res/android'}))
            .pipe(gulp.dest("platforms/android"));
    });

    gulp.task('android-application', function() {
        return gulp.src("platforms/android/src/com/sum/cordova/leancloud/LeanApplication.java")
            .pipe(replace('<%MAINACTIVITY%>', config.mainActivity))
            .pipe(replace('<%APPID%>', config.leanAppId))
            .pipe(replace('<%APPKEY%>', config.leanAppKey))
            .pipe(gulp.dest("platforms/android/src/com/sum/cordova/leancloud"));
    });
