module.exports = function(root, done) {
    var path = require('path');
    var fs = require('fs');
    var xml2js = require('xml2js');
    var parser = new xml2js.Parser();
    var builder = new xml2js.Builder();

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
                        }, done);
                    }
                });
            }
        });

    // Patch
    function patchSource(opt, done) {
        // 修改AndroidManifest 中的Application Entry
        var android_manifest_path = path.join(root, "platforms/android/AndroidManifest.xml");
        fs.readFile(android_manifest_path,
            function(err, data) {
                var source = data.toString();
                parser.parseString(source, function(err, result) {
                    if (err)
                        throw err;
                    result.manifest.application[0].$['android:name'] = 'me.xyzhang.cordova.leanpush.LeanApplication';
                    var xml = builder.buildObject(result);
                    fs.writeFile(android_manifest_path, xml, function(err) {
                        if (err)
                            throw err;
                        // 代码中插入LeanCLoud Key,Id 相关信息， 并且讲MainActivity名字import进去
                        var lean_application_path = path.join(root, "platforms/android/src/me/xyzhang/cordova/leanpush/LeanApplication.java");
                        fs.readFile(lean_application_path,
                            function(err, data) {
                                if (err)
                                    throw err;
                                var source = data.toString().replace('<%LEAN_APP_ID%>', opt.app_id).replace('<%LEAN_APP_KEY%>', opt.app_key).replace('<%PACKAGE_NAME%>', opt.package_name);
                                fs.writeFile(lean_application_path, source, function(err) {
                                    if (err)
                                        throw err;
                                    // 替换项目的MainActivity.java
                                    var main_activity_dir_path = path.join(root, 'platforms/android/src/');
                                    opt.package_name.split('.').forEach(function(name) {
                                        main_activity_dir_path = path.join(main_activity_dir_path, name);
                                    });
                                    var lpush_main_activity_path = path.join(root, 'plugins/cordova-plugin-leanpush/other/MainActivity.java');
                                    fs.readFile(lpush_main_activity_path, function(err, data) {
                                        var source = data.toString().replace('<%PACKAGE_NAME%>', opt.package_name);
                                        fs.writeFile(path.join(main_activity_dir_path, 'MainActivity.java'), source, function(err) {
                                            if (!err)
                                                done();
                                            else
                                                throw err;
                                        });
                                    });
                                });
                            });
                    });
                });
            });
    }
};


// 我应该用thunk一类的库的，只是开始写的感觉应该无所谓。。。。结果就是这个丑样子.......惭愧
