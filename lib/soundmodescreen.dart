import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({Key? key}) : super(key: key);

  @override
  _SoundScreenState createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  String? _permissionStatus;

  @override
  void initState() {
    super.initState();
    _getCurrentSoundMode();
    _getPermissionStatus();
  }

  Future<void> _getCurrentSoundMode() async {
    RingerModeStatus ringerStatus = RingerModeStatus.unknown;

    Future.delayed(const Duration(seconds: 1), () async {
      try {
        ringerStatus = await SoundMode.ringerModeStatus;
      } catch (err) {
        ringerStatus = RingerModeStatus.unknown;
      }

      setState(() {
        _soundMode = ringerStatus;
      });
    });
  }

  Future<void> _getPermissionStatus() async {
    bool? permissionStatus = false;
    try {
      permissionStatus = await PermissionHandler.permissionsGranted;
      print(permissionStatus);
    } catch (err) {
      print(err);
    }

    setState(() {
      _permissionStatus =
          permissionStatus! ? "Permissions Enabled" : "Permissions not granted";
    });
  }

  Future<void> _setSilentMode() async {
    RingerModeStatus status;
    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.silent);
      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> _setNormalMode() async {
    RingerModeStatus status;
    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.normal);
      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> _setVibrateMode() async {
    RingerModeStatus status;
    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> _openDoNotDisturbSettings() async {
    await PermissionHandler.openDoNotDisturbSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Silencer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Running on: $_soundMode'),
            Text('Permission status: $_permissionStatus'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentSoundMode,
              child: const Text('Get current sound mode'),
            ),
            ElevatedButton(
              onPressed: _setNormalMode,
              child: const Text('Set Normal mode'),
            ),
            ElevatedButton(
              onPressed: _setSilentMode,
              child: const Text('Set Silent mode'),
            ),
            ElevatedButton(
              onPressed: _setVibrateMode,
              child: const Text('Set Vibrate mode'),
            ),
            ElevatedButton(
              onPressed: _openDoNotDisturbSettings,
              child: const Text('Open Do Not Disturb Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
