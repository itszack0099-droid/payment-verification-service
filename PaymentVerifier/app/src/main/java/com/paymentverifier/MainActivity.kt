package com.paymentverifier

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat

class MainActivity : AppCompatActivity() {

    companion object {
        private const val TAG = "PaymentVerifier"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btnEnable = findViewById<Button>(R.id.btnEnableNotification)
        btnEnable.setOnClickListener {
            handleNotificationPermission()
        }
    }

    override fun onResume() {
        super.onResume()
        updateUI()
    }

    private fun isNotificationListenerEnabled(): Boolean {
        val enabledPackages = NotificationManagerCompat.getEnabledListenerPackages(this)
        val isEnabled = enabledPackages.contains(packageName)
        Log.d(TAG, "Permission status detected: isNotificationListenerEnabled=$isEnabled (package=$packageName)")
        return isEnabled
    }

    private fun handleNotificationPermission() {
        if (isNotificationListenerEnabled()) {
            Log.d(TAG, "Permission already granted — skipping settings screen")
            showPermissionGranted()
        } else {
            Log.d(TAG, "Permission not granted — opening notification listener settings")
            val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
            startActivity(intent)
        }
    }

    private fun updateUI() {
        val tvStatus = findViewById<TextView>(R.id.tvStatus)
        val btnEnable = findViewById<Button>(R.id.btnEnableNotification)

        if (isNotificationListenerEnabled()) {
            tvStatus.text = "Notification permission enabled successfully."
            btnEnable.text = "Permission Granted"
            btnEnable.isEnabled = false
        } else {
            tvStatus.text = "Service Ready"
            btnEnable.text = "Enable Notification Access"
            btnEnable.isEnabled = true
        }
    }

    private fun showPermissionGranted() {
        val tvStatus = findViewById<TextView>(R.id.tvStatus)
        val btnEnable = findViewById<Button>(R.id.btnEnableNotification)
        tvStatus.text = "Notification permission enabled successfully."
        btnEnable.text = "Permission Granted"
        btnEnable.isEnabled = false
        Log.d(TAG, "UI updated — permission granted state shown")
    }
}
