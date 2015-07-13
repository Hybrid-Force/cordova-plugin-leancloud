module.exports = function(root, gulp, gulp_done) {
    var path = require('path');
    var fs = require('fs');
    var xml2js = require('xml2js');
    var parser = new xml2js.Parser();
    var xeditor = require('gulp-xml-editor');
    var replace = require('gulp-replace');
    var cp = require('node-cp');

    // get APPID & APPKEY & PACKAGE_NAME
    fs.readFile(path.join(root, 'platforms/android/res/xml/config.xml'),
        function(err, data) {
            if (err)
                throw err;
            else {
                parser.parseString(data, function(err, result) {
                    if (err)
                        throw err;
                    else {
                        var app_id, app_key, package_name;
                        package_name = result.widget.$.id;
                        result.widget.preference.forEach(function(item) {
                            if (item.$.name == 'leancloud-appid') {
                                app_id = item.$.value;
                            }
                            if (item.$.name == 'leancloud-appkey') {
                                app_key = item.$.value;
                            }
                        });
                        patchSource({
                            app_id: app_id,
                            app_key: app_key,
                            package_name: package_name
                        }, gulp, gulp_done);
                    }
                });
            }
        });


    // Patch
    function patchSource(opt, gulp, gulp_done) {

        // Modify android application setting
        gulp.src(path.join(root, "platforms/android/AndroidManifest.xml"))
            .pipe(xeditor([{
                path: '/manifest/application',
                attr: {
                    'android:name': 'me.xyzhang.cordova.leanpush.LeanApplication'
                }
            }], {
                'android': 'http://schemas.android.com/apk/res/android'
            }))
            .pipe(gulp.dest(path.join(root, "platforms/android")));

        // Patching LeanApplication.java
        gulp.src(path.join(root, "platforms/android/src/me/xyzhang/cordova/leanpush/LeanApplication.java"))
            .pipe(replace('<%PACKAGE_NAME%>', opt.package_name))
            .pipe(replace('<%LEAN_APP_ID%%>', opt.app_id))
            .pipe(replace('<%LEAN_APP_KEY%%>', opt.app_key))
            .pipe(gulp.dest(path.join(root, "platforms/android/src/me/xyzhang/cordova/leanpush")));

        // Replace the MainActivity.java
        var main_activity_path = path.join(root, 'platforms/android/src/');
        opt.package_name.split('.').forEach(function(name){
            main_activity_path = path.join(main_activity_path, name);
        });
        main_activity_path = path.join(main_activity_path, 'MainActivity.java');
        console.log(main_activity_path);

        var lpush_main_activity_path = path.join(root,'plugins/cordova-plugin-leanpush/other/MainActivity.java');
        cp(lpush_main_activity_path, main_activity_path, function (err, files) {
            if (err) {
                throw err;
            }
            gulp_done();
        });
    }

};
