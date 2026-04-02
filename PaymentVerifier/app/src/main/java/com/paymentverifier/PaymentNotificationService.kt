package com.paymentverifier

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class PaymentNotificationService : NotificationListenerService() {

    companion object {
        private const val TAG = "PaymentNotifService"
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val extras = sbn.notification.extras
        val title = extras.getString("android.title") ?: ""
        val text = extras.getCharSequence("android.text")?.toString() ?: ""
        Log.d(TAG, "Notification from: ${sbn.packageName}")
        Log.d(TAG, "Title: $title")
        Log.d(TAG, "Text: $text")
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        Log.d(TAG, "Notification removed from: ${sbn.packageName}")
    }
}
