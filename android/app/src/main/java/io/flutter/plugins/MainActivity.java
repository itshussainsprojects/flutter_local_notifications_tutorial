package com.example.flutter_local_notifications_tutorial; // Ensure this matches your package name

import android.content.Context;
import android.media.AudioManager;
import androidx.annotation.NonNull; // Add this import
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example/flutter_silence";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
                if (call.method.equals("silencePhone")) {
                    silencePhone();
                    result.success("Phone silenced");
                } else {
                    result.notImplemented();
                }
            }
        );
    }

    private void silencePhone() {
        AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        if (audioManager != null) {
            audioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);  // Set phone to silent mode
        }
    }
}
