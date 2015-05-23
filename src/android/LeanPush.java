package com.sum.cordova.leancloud;

import java.util.Arrays;
import java.util.ArrayList;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.avos.avoscloud.PushService;
import com.avos.avoscloud.AVInstallation;
import com.avos.avoscloud.AVOSCloud;

/**
 * This class echoes a string called from JavaScript.
 */
public class LeanPush extends CordovaPlugin {

    public static final String PROP_KEY_LEANCLOUD_APP_ID = "leancloud-appid";
    public static final String PROP_KEY_LEANCLOUD_APP_KEY = "leancloud-appkey";

    public static final String ACTION_SUBSCRIBE = "subscribe";
    public static final String ACTION_UNSUBSCRIBE = "unsubscribe";
    public static final String ACTION_CLEAR_SUBSCRIPTION = "clearSubscription";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        // String appId = this.preferences.getString(PROP_KEY_LEANCLOUD_APP_ID, "");
        // String appKey = this.preferences.getString(PROP_KEY_LEANCLOUD_APP_KEY, "");
        
        // if (appId != null && !appId.isEmpty() &&
        //     appKey != null && !appKey.isEmpty()) {
        //     AVOSCloud.initialize(cordova.getActivity(), appId, appKey);
        //     PushService.setDefaultPushCallback(cordova.getActivity(), cordova.getActivity().getClass());
        //     AVInstallation.getCurrentInstallation().saveInBackground();
        // }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_SUBSCRIBE)) {
            this.subscribe(args.getString(0), callbackContext);
            return true;
        }
        if (action.equals(ACTION_UNSUBSCRIBE)) {
            this.unsubscribe(args.getString(0), callbackContext);
            return true;
        }
        if (action.equals(ACTION_CLEAR_SUBSCRIPTION)) {
            this.clearSubscription(callbackContext);
            return true;
        }
        return false;
    }

    private void subscribe(final String channel, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                PushService.subscribe(cordova.getActivity(), channel, cordova.getActivity().getClass());
                callbackContext.success();
            }
        });
    }

    private void unsubscribe(final String channel, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                PushService.unsubscribe(cordova.getActivity(), channel);
                callbackContext.success();
            }
        });
    }

    private void clearSubscription(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                AVInstallation currentInstallation = AVInstallation.getCurrentInstallation();
                currentInstallation.put("channels", new ArrayList());
                currentInstallation.saveInBackground();
                callbackContext.success();
            }
        });
    }
}
