import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_tutorial/settings_screen.dart';
import 'package:flutter_local_notifications_tutorial/soundmodescreen.dart';
import 'home_screen.dart';
import 'about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silent Mode Automation',
      theme: ThemeData(
        fontFamily: 'PaulJackson',
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/sound': (context) => const SoundScreen(),
      },
    );
  }
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sound_mode/utils/ringer_mode_statuses.dart';
// import 'package:sound_mode/sound_mode.dart'; // Correct import
// import 'package:permission_handler/permission_handler.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:geolocator/geolocator.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   RingerModeStatus _soundMode =
//       RingerModeStatus.unknown; // Correct usage of RingerModeStatus
//   String? _permissionStatus;
//   bool? _locationPermissionGranted;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentSoundMode();
//     _getPermissionStatus();
//   }

//   Future<void> _getCurrentSoundMode() async {
//     RingerModeStatus ringerStatus = RingerModeStatus.unknown;

//     try {
//       ringerStatus = await SoundMode.ringerModeStatus;
//     } catch (err) {
//       ringerStatus = RingerModeStatus.unknown;
//     }

//     setState(() {
//       _soundMode = ringerStatus;
//     });
//   }

//   Future<void> _getPermissionStatus() async {
//     // Check if Do Not Disturb permission is granted
//     var permissionStatus = await Permission.notification.status;
//     setState(() {
//       _permissionStatus = permissionStatus.isGranted
//           ? "Do Not Disturb Permission Granted"
//           : "Do Not Disturb Permission Not Granted";
//     });
//   }

//   Future<void> _setSilentMode() async {
//     try {
//       RingerModeStatus status = await SoundMode.setSoundMode(
//           RingerModeStatus.silent); // Correct usage
//       setState(() {
//         _soundMode = status;
//       });
//     } on PlatformException {
//       print('Do Not Disturb access permissions required!');
//     }
//   }

//   Future<void> _setNormalMode() async {
//     try {
//       RingerModeStatus status = await SoundMode.setSoundMode(
//           RingerModeStatus.normal); // Correct usage
//       setState(() {
//         _soundMode = status;
//       });
//     } on PlatformException {
//       print('Do Not Disturb access permissions required!');
//     }
//   }

//   Future<void> _setVibrateMode() async {
//     try {
//       RingerModeStatus status = await SoundMode.setSoundMode(
//           RingerModeStatus.vibrate); // Correct usage
//       setState(() {
//         _soundMode = status;
//       });
//     } on PlatformException {
//       print('Do Not Disturb access permissions required!');
//     }
//   }

//   Future<void> _openDoNotDisturbSettings() async {
//     // Open the system settings for Do Not Disturb mode
//     if (await Permission.notification.isGranted) {
//       print("Do Not Disturb permission already granted");
//     } else {
//       print("Do Not Disturb Permission not granted. Opening settings...");
//       // Open app settings for the user to manually grant permission
//       openAppSettings();
//     }
//   }

//   Future<void> _getUserLocation() async {
//     // Check and request location permission
//     PermissionStatus locationPermission = await Permission.location.request();
//     if (locationPermission.isGranted) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("User Location: ${position.latitude}, ${position.longitude}");
//     } else {
//       print("Location permission not granted");
//       openAppSettings(); // Open settings to allow location permission
//     }
//   }

//   // Schedule Silent Mode Activation at 2 PM
//   Future<void> _scheduleSilentMode() async {
//     await _getUserLocation(); // Get user's location

//     final now = DateTime.now();
//     final scheduledTime =
//         DateTime(now.year, now.month, now.day, 14, 0); // 2 PM today

//     // Create notification for silent mode activation
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 0,
//         channelKey: 'silent_mode_channel',
//         title: 'Silent Mode Scheduled',
//         body: 'Silent mode will activate at 2:00 PM today.',
//       ),
//     );

//     // Schedule activation of silent mode
//     Future.delayed(scheduledTime.difference(now), () async {
//       await _setSilentMode();
//       print("Silent mode activated at 2 PM");
//       // Deactivate after 20 minutes
//       Future.delayed(const Duration(minutes: 20), () async {
//         await _setNormalMode();
//         print("Silent mode deactivated after 20 minutes");
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Silent Mode Automation'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Running on: $_soundMode'),
//               Text('Permission status: $_permissionStatus'),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: () => _getCurrentSoundMode(),
//                 child: const Text('Get current sound mode'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _setNormalMode(),
//                 child: const Text('Set Normal mode'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _setSilentMode(),
//                 child: const Text('Set Silent mode'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _setVibrateMode(),
//                 child: const Text('Set Vibrate mode'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _openDoNotDisturbSettings(),
//                 child: const Text('Open Do Not Disturb Settings'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _scheduleSilentMode(),
//                 child: const Text('Schedule Silent Mode at 2 PM'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
