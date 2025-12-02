# Flutter Demo Setup Guide for Android

## 1. Import the Project
1. Open **Android Studio**
2. Click **File → Open** and select the root directory of the Flutter demo (`flutter_plugin_qpos`)
3. Android Studio will automatically recognize it as a Flutter project and configure the environment accordingly

## 2. Run the Demo
1. Ensure the main entry file `main.dart` (located in `example/lib/`) is open in the editor
2. Click the **green Run button** ▶️ in the toolbar to build and launch the demo on a connected device or emulator

## 3. Update the Android Module (If Needed)
If you need to modify or rebuild the native Android module separately:
1. Click **File → Open** again
2. Navigate to and select the `flutter_plugin_qpos/example/android` folder
3. This will open the Android module as a standalone project for advanced native-level development or debugging

---

## Prerequisites
- Flutter SDK installed and configured in Android Studio
- Android device/emulator with USB debugging enabled

## Troubleshooting
- If the project fails to sync, run `flutter pub get` in the terminal
- Ensure all Android SDK tools and licenses are properly installed

> **Note:** If you encounter any issues during setup, please check the project's documentation or contact support for further assistance.
