package com.sum.cordova.leancloud;

import android.app.Application;
import android.content.Context;

import com.avos.avoscloud.PushService;
import com.avos.avoscloud.AVInstallation;
import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.AVAnalytics;

import <%MAINACTIVITY%>;

public class LeanApplication extends Application 
{
    private static LeanApplication instance = new LeanApplication();

    public LeanApplication() {
        instance = this;
    }

    public static Context getContext() {
        return instance;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        // register device for leancloud
        AVOSCloud.initialize(this, "<%APPID%>", "<%APPKEY%>");
        PushService.setDefaultPushCallback(this, MainActivity.class);
        AVInstallation.getCurrentInstallation().saveInBackground();
        AVAnalytics.enableCrashReport(this, true);
    }
}