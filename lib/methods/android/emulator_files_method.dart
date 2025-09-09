import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks for emulator-specific files and directories.
///
/// This method looks for files and directories that are commonly present in Android emulators
/// but not on physical devices. It checks for:
/// - QEMU-related files (qemu_pipe, qemud, qemu-props, etc.)
/// - Android emulator system files (gralloc.goldfish.so, gralloc.ranchu.so)
/// - Genymotion emulator files (genyd, baseband_genyd)
///
/// **Reliability**: High (90-95%)
/// - Very reliable for detecting standard Android emulators
/// - May have false positives on rooted devices with emulator files
/// - Some emulators may hide these files to avoid detection
///
/// **Score**: 25 points when emulator files are detected
///
/// **Performance**: Asynchronous file operations to avoid blocking UI thread
class EmulatorFilesMethod extends EmulatorDetectionMethod {
  EmulatorFilesMethod({
    super.score = 25,
    super.reason = "Emulator-specific files detected",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final detectedFiles = await _getDetectedEmulatorFiles();
      if (detectedFiles.isNotEmpty) {
        return (score: score, reason: "$reason: ${detectedFiles.join(', ')}");
      }
    }

    return (score: 0.0, reason: null);
  }

  Future<List<String>> _getDetectedEmulatorFiles() async {
    final detectedFiles = <String>[];

    const emulatorFiles = [
      '/dev/qemu_pipe',
      '/sys/class/android_usb/android0/state',
      '/dev/socket/qemud',
      '/system/lib/libc_malloc_debug_qemu.so',
      '/sys/qemu_trace',
      '/system/bin/qemu-props',
      '/dev/socket/genyd',
      '/dev/socket/baseband_genyd',
    ];

    // Check files asynchronously
    final fileChecks = emulatorFiles.map((file) => _checkFileExists(file));
    final fileResults = await Future.wait(fileChecks);

    for (int i = 0; i < emulatorFiles.length; i++) {
      if (fileResults[i]) {
        detectedFiles.add(emulatorFiles[i]);
      }
    }

    // Check for emulator-specific directories
    const emulatorDirs = [
      '/system/lib/hw/gralloc.goldfish.so',
      '/system/lib/hw/gralloc.ranchu.so',
    ];

    final dirChecks = emulatorDirs.map((dir) => _checkFileExists(dir));
    final dirResults = await Future.wait(dirChecks);

    for (int i = 0; i < emulatorDirs.length; i++) {
      if (dirResults[i]) {
        detectedFiles.add(emulatorDirs[i]);
      }
    }

    return detectedFiles;
  }

  /// Asynchronously check if a file exists
  Future<bool> _checkFileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      // If we can't check the file (permissions, etc.), assume it doesn't exist
      return false;
    }
  }
}
