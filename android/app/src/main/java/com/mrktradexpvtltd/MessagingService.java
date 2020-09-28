package com.mrktradexpvtltd;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;

import static android.media.RingtoneManager.getDefaultUri;

@SuppressWarnings("All")
public class MessagingService extends FirebaseMessagingService {

    private String CHANNEL_ID = "mrk.channel.id";
    private String CHANNEL_NAME = "MRK Channel Name";

    private int getIcon() {
        boolean useWhiteIcon = Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP;
        return useWhiteIcon ? R.drawable.ic_notification : R.mipmap.ic_launcher;
    }

    private int getColor() {

        return Color.BLUE;
    }

    void showLog(Object object) {
        // MessagingService
        Log.d("MessagingService", "Template payload: " + object);
    }

    @Override
    public void onDeletedMessages() {
        showLog("onDeletedMessages ");
        super.onDeletedMessages();
    }

    @Override
    public void onNewToken(String s) {
        super.onNewToken(s);
        showLog("OnNewToken " + s);
    }

    @Override
    public void onMessageSent(String s) {
        showLog("onMessageSent " + s);
        super.onMessageSent(s);
    }

    @Override
    public void onSendError(String s, Exception e) {
        super.onSendError(s, e);
        e.printStackTrace();
        showLog(e);
    }

    @Override
    public void onMessageReceived(RemoteMessage message) {
        super.onMessageReceived(message);
        try {
            Map<String, String> payload = message.getData();
            showLog("Template payload: " + payload);
            getManager().notify(10, getNotification(payload));
        }
        //NullPointerException
        catch (NullPointerException e) {
            e.printStackTrace();
        }
        // Exception
        catch (Exception e) {
            e.printStackTrace();
        }

    }

    // Notification Manager
    private NotificationManager getManager() {
        Object object = getSystemService(Context.NOTIFICATION_SERVICE);
        return createChannel((NotificationManager) object);
    }

    private Notification getNotification(Map<String, String> notify) {

        Intent intent1 = new Intent(this, MainActivity.class);
        intent1.putExtra("DATA", String.valueOf(notify));
        intent1.putExtra("data", String.valueOf(notify));
        intent1.putExtra("", String.valueOf(notify));

        intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent1.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);

        PendingIntent pendingIntent = PendingIntent.getActivity(this,
                8099, intent1, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.BigTextStyle bigTextStyle = new NotificationCompat.BigTextStyle();
        Uri alarmSound = getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        bigTextStyle.setBigContentTitle(notify.get("title"));
        bigTextStyle.bigText(notify.get("body"));

        return new NotificationCompat.Builder(this, CHANNEL_ID)
                .setDefaults(Notification.DEFAULT_VIBRATE)
                .setPriority(Notification.PRIORITY_HIGH)
                .setContentTitle(notify.get("title"))
                .setContentText(notify.get("body"))
                .setContentIntent(pendingIntent)
                .setSmallIcon(getIcon())
                .setStyle(bigTextStyle)
                .setColor(getColor())
                .setSound(alarmSound)
                .setAutoCancel(true)
                .build();


    }

    private NotificationManager createChannel(NotificationManager manager) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(CHANNEL_ID,
                    CHANNEL_NAME, manager.IMPORTANCE_HIGH);
            notificationChannel.enableLights(true);
            notificationChannel.setLightColor(Color.RED);
            notificationChannel.setShowBadge(true);
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            manager.createNotificationChannel(notificationChannel);
        }

        return manager;

    }

}
