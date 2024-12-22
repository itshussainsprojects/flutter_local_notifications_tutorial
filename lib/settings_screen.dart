import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const platform = MethodChannel('com.example.silentmode');
  TimeOfDay? customTime;

  String actionLog = '';

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
    _scheduleDefaultSilentMode();
  }

  // Initialize AwesomeNotifications
  Future<void> _initializeNotifications() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'silent_mode_channel',
          channelName: 'Silent Mode Notifications',
          channelDescription: 'Notification when the silent mode is scheduled.',
          defaultColor: const Color(0xFF9D50BB),
          ledColor: Colors.white,
        )
      ],
    );
  }

  Future<void> _getUserLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    debugPrint("User Location: ${position.latitude}, ${position.longitude}");
  }

  void _scheduleDefaultSilentMode() {
    _scheduleSilentMode(const TimeOfDay(hour: 14, minute: 0));
  }

  Future<void> _scheduleSilentMode(TimeOfDay time) async {
    await _getUserLocation();

    final now = DateTime.now();
    final scheduledTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Create notification for silent mode
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'silent_mode_channel',
        title: 'Silent Mode Scheduled',
        body: 'Silent mode will activate at ${time.format(context)}.',
      ),
    );

    // Schedule activation of silent mode
    Future.delayed(tzTime.difference(DateTime.now()), () async {
      await platform.invokeMethod('setSilentMode');
      _updateActionLog('Silent mode activated at ${tzTime.toString()}');

      // Deactivate after 20 minutes
      Future.delayed(const Duration(minutes: 20), () async {
        await platform.invokeMethod('revertSilentMode');
        _updateActionLog(
            'Silent mode deactivated at ${tzTime.add(const Duration(minutes: 20)).toString()}');

        // Send a notification when silent mode is deactivated
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'silent_mode_channel',
            title: 'Silent Mode Restored',
            body: 'Silent mode has been restored.',
          ),
        );
      });
    });
  }

  Future<void> _pickCustomTime() async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      setState(() {
        customTime = pickedTime;
      });
      _scheduleSilentMode(pickedTime);
    }
  }

  void _updateActionLog(String action) {
    setState(() {
      actionLog = '$action\n$actionLog';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Silent Mode Automation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickCustomTime,
              child: const Text('Set Custom Silent Mode Time'),
            ),
            const SizedBox(height: 20),
            if (customTime != null)
              Text(
                'Custom Silent Mode Time: ${customTime!.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(55.0),
              child: Text(
                'Action Log:\n$actionLog',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart'; // For audio
// import 'package:vibration/vibration.dart'; // For vibration

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   static const platform = MethodChannel('com.example.silentmode');
//   TimeOfDay? customTime;

//   String actionLog = '';
//   late AudioPlayer player;
//   late RingerModeStatus status;

//   @override
//   void initState() {
//     super.initState();
//     tz.initializeTimeZones();
//     _initializeNotifications();
//     _scheduleDefaultSilentMode();
//     player = AudioPlayer(); // Initialize audio player for sound checks
//   }

//   // Initialize AwesomeNotifications
//   Future<void> _initializeNotifications() async {
//     AwesomeNotifications().initialize(
//       'resource://drawable/res_app_icon',
//       [
//         NotificationChannel(
//           channelKey: 'silent_mode_channel',
//           channelName: 'Silent Mode Notifications',
//           channelDescription: 'Notification when the silent mode is scheduled.',
//           defaultColor: const Color(0xFF9D50BB),
//           ledColor: Colors.white,
//         )
//       ],
//     );
//   }

//   Future<void> _getUserLocation() async {
//     await Geolocator.requestPermission();
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best);
//     debugPrint("User Location: ${position.latitude}, ${position.longitude}");
//   }

//   void _scheduleDefaultSilentMode() {
//     _scheduleSilentMode(const TimeOfDay(hour: 14, minute: 0));
//   }

//   Future<void> _scheduleSilentMode(TimeOfDay time) async {
//     await _getUserLocation();

//     final now = DateTime.now();
//     final scheduledTime =
//         DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

//     // Create notification for silent mode
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 0,
//         channelKey: 'silent_mode_channel',
//         title: 'Silent Mode Scheduled',
//         body: 'Silent mode will activate at ${time.format(context)}.',
//       ),
//     );

//     // Schedule activation of silent mode
//     Future.delayed(tzTime.difference(DateTime.now()), () async {
//       await platform.invokeMethod('setSilentMode');
//       _updateActionLog('Silent mode activated at ${tzTime.toString()}');

//       // Deactivate after 20 minutes
//       Future.delayed(const Duration(minutes: 20), () async {
//         await platform.invokeMethod('revertSilentMode');
//         _updateActionLog(
//             'Silent mode deactivated at ${tzTime.add(const Duration(minutes: 20)).toString()}');

//         // Send a notification when silent mode is deactivated
//         await AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: 1,
//             channelKey: 'silent_mode_channel',
//             title: 'Silent Mode Restored',
//             body: 'Silent mode has been restored.',
//           ),
//         );
//       });
//     });
//   }

//   Future<void> _pickCustomTime() async {
//     final pickedTime =
//         await showTimePicker(context: context, initialTime: TimeOfDay.now());
//     if (pickedTime != null) {
//       setState(() {
//         customTime = pickedTime;
//       });
//       _scheduleSilentMode(pickedTime);
//     }
//   }

//   void _updateActionLog(String action) {
//     setState(() {
//       actionLog = '$action\n$actionLog';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Silent Mode Automation'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back), // Back arrow icon
//           onPressed: () {
//             Navigator.pop(context); // Go back to the previous screen
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickCustomTime,
//               child: const Text('Set Custom Silent Mode Time'),
//             ),
//             const SizedBox(height: 20),
//             if (customTime != null)
//               Text(
//                 'Custom Silent Mode Time: ${customTime!.format(context)}',
//                 style: const TextStyle(fontSize: 16),
//               ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(55.0),
//               child: Text(
//                 'Action Log:\n$actionLog',
//                 style: const TextStyle(fontSize: 14),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

