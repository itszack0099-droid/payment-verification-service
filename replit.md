# Payment Verification Service

## Overview
This repo contains two components:
1. A Node.js/Express web app (at root) — the main payment verification UI with Supabase integration
2. A native Android app in Kotlin called **PaymentVerifier** (in `PaymentVerifier/`)

---

## Web App (Node.js + Express)

### Architecture
- **Runtime**: Node.js 20
- **Framework**: Express
- **Entry point**: `src/index.js`
- **Frontend**: `src/public/index.html` (vanilla HTML/JS with Supabase JS client)
- **Port**: 5000 (host: 0.0.0.0)

### Supabase Integration
- **URL**: `https://siujmsbmvwxxbdhlihgd.supabase.co`
- **Functions used**:
  - `create_payment_request(user_id, name, phone, amount)` → `{request_id, final_amount}`
  - `check_payment_status(request_id)` → `{status}` (`pending` | `approved` | `expired`)

### Features
- **Create Payment**: Calls Supabase `create_payment_request` with amount ₹149 (INR default)
- **Verify Payment**: Calls Supabase `check_payment_status` with request_id
- **Auto-refresh**: Polls payment status every 5s for up to 120s after creation
- **Currency**: INR (₹) default, USD ($) option
- **Recent Verifications**: Shows last 20 verifications with request ID, amount, status, time

### Running
```
npm run dev
```

### Endpoints
- `GET /`       - Serves the Payment Verification UI
- `GET /health` - Health check JSON

### Deployment
Configured for autoscale deployment. Run command: `node src/index.js`

---

## Android App (PaymentVerifier/)

### Details
- **Language**: Kotlin
- **Package**: `com.paymentverifier`
- **Min SDK**: 26 | **Target SDK**: 34 | **Compile SDK**: 34
- **AGP Version**: 8.1.4

### Key Files
```
PaymentVerifier/
  app/src/main/java/com/paymentverifier/
    MainActivity.kt                 - UI with "Enable Notification Access" button
    PaymentNotificationService.kt   - NotificationListenerService stub
  app/src/main/res/layout/activity_main.xml
  app/src/main/AndroidManifest.xml
```

### Building the APK (locally)
```bash
export JAVA_HOME=/nix/store/c8hr2f0b0dm685yx1dkp6bw24bpx495n-graalvm19-ce-22.3.1
export ANDROID_HOME=/home/runner/android-sdk
export PATH=$JAVA_HOME/bin:$PATH
cd PaymentVerifier && gradle assembleDebug --no-daemon
```
Output: `PaymentVerifier/app/build/outputs/apk/debug/app-debug.apk`

### CI/CD
GitHub Actions workflow at `.github/workflows/build_apk.yml` automatically builds
the APK on every push to `main` and uploads it as an artifact.

---

## pubspec.yaml
Flutter/Dart project metadata file at root for potential future Flutter migration.
Includes `supabase_flutter` dependency.
