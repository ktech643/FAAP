# Firebase Crashlytics iOS Setup Guide

This guide outlines the final manual steps required to fully configure Firebase Crashlytics for your Flutter iOS app. 

The core Flutter and Android configuration has already been completed. For iOS, you must add a Run Script in Xcode so that Crashlytics can automatically upload dSYM (debugging symbol) files. Without these files, your iOS crash reports will show unreadable memory addresses instead of human-readable line numbers and file names.

---

## Prerequisites
- You must perform these steps on a Mac.
- You must have Xcode installed.
- Ensure you have run `flutter pub get` and `cd ios && pod install` (or simply built the app for iOS once via `flutter run`) so that the CocoaPods are installed.

---

## Step-by-Step Instructions

### 1. Open your project in Xcode
Open the `.xcworkspace` file (not the `.xcodeproj` file) in Xcode.
You can do this from the terminal:
```bash
open ios/Runner.xcworkspace
```

### 2. Navigate to Build Phases
1. In the Project Navigator (left sidebar) of Xcode, click on the **Runner** project at the very top.
2. In the center pane, select the **Runner** target (under the "TARGETS" header).
3. Click on the **Build Phases** tab at the top.

### 3. Add a New Run Script Phase
1. Click the small **+** icon located at the top-left corner of the Build Phases section.
2. Select **New Run Script Phase** from the dropdown menu.
3. A new section titled "Run Script" will appear at the bottom of the Build Phases list. Expand it.
   - *(Optional but recommended: Double-click the title "Run Script" and rename it to "Crashlytics dSYM Upload" for clarity).*

### 4. Configure the Run Script
1. Inside the new Run Script section, locate the text box under the **Shell** field (which usually contains `Type a script or drag a script file from your workspace to insert its path`).
2. Paste the following exact path into that text box:
   ```bash
   "${PODS_ROOT}/FirebaseCrashlytics/run"
   ```

### 5. Add the Input Files
For the script to find the correct files to upload, you must provide their paths.
1. Still inside the Run Script section, find the **Input Files** area.
2. Click the **+** button under Input Files to add a new row.
3. Paste the following path into the new row:
   ```text
   ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}
   ```
4. Click the **+** button again to add a second row.
5. Paste the following path into the second row:
   ```text
   $(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)
   ```

---

## Verification

You are done! The next time you build and run your app from Xcode (or via Flutter on a Mac), this script will automatically execute and securely upload your app's debug symbols to Firebase. 

If you force a crash using `FirebaseCrashlytics.instance.crash();` on an iOS device, it will now appear perfectly translated in your Firebase Console dashboard!
