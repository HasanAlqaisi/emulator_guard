import 'package:flutter/material.dart';
import 'package:emulator_guard/emulator_guard.dart';
import 'package:emulator_guard/methods/base_method.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(const MyApp());
}

/// Custom detection method that checks for suspicious device names
/// This is an example of how to create your own detection method
class CustomDeviceNameMethod extends BaseMethod {
  CustomDeviceNameMethod({
    super.score = 75,
    super.reason = "Suspicious device name detected",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    String? deviceName;
    if (deviceInfo is AndroidDeviceInfo) {
      deviceName = deviceInfo.model;
    } else if (deviceInfo is IosDeviceInfo) {
      deviceName = deviceInfo.name;
    }

    if (deviceName != null) {
      // Check for common emulator device names
      final suspiciousNames = [
        'emulator',
        'simulator',
        'sdk_gphone',
        'android sdk',
        'google_sdk',
        'droid4x',
        'nox',
        'bluestacks',
        'genymotion',
        'andy',
        'memu',
        'ldplayer',
        'mumu',
        'x86_64',
        'generic',
        'unknown',
      ];

      final lowerDeviceName = deviceName.toLowerCase();
      for (final suspiciousName in suspiciousNames) {
        if (lowerDeviceName.contains(suspiciousName)) {
          return (score: score, reason: '$reason: "$deviceName"');
        }
      }
    }

    return (score: 0.0, reason: null);
  }
}

/// Custom detection method that checks for suspicious hardware characteristics
/// This demonstrates checking hardware properties
class CustomHardwareMethod extends BaseMethod {
  CustomHardwareMethod({
    super.score = 60,
    super.reason = "Suspicious hardware characteristics detected",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      // Check for suspicious hardware characteristics
      final manufacturer = deviceInfo.manufacturer.toLowerCase();
      final model = deviceInfo.model.toLowerCase();
      final board = deviceInfo.board.toLowerCase();
      final hardware = deviceInfo.hardware.toLowerCase();

      // Check for common emulator hardware patterns
      final suspiciousPatterns = [
        'goldfish', // Android emulator
        'ranchu', // Android emulator
        'vbox', // VirtualBox
        'vmware', // VMware
        'qemu', // QEMU
        'generic', // Generic hardware
        'unknown', // Unknown hardware
        'sdk', // SDK emulator
        'google_sdk', // Google SDK
      ];

      for (final pattern in suspiciousPatterns) {
        if (manufacturer.contains(pattern) ||
            model.contains(pattern) ||
            board.contains(pattern) ||
            hardware.contains(pattern)) {
          return (
            score: score,
            reason: '$reason: $pattern found in hardware info',
          );
        }
      }

      // Check for suspicious device characteristics
      if (deviceInfo.isPhysicalDevice == false) {
        return (
          score: score,
          reason: '$reason: DeviceInfo reports non-physical device',
        );
      }
    }

    return (score: 0.0, reason: null);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emulator Guard Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmulatorGuardExample(),
    );
  }
}

class EmulatorGuardExample extends StatefulWidget {
  const EmulatorGuardExample({super.key});

  @override
  State<EmulatorGuardExample> createState() => _EmulatorGuardExampleState();
}

class _EmulatorGuardExampleState extends State<EmulatorGuardExample> {
  EmulatorCheckResult? _result;
  bool _isLoading = false;
  String _error = '';
  bool _useCustomMethods = false;

  Future<void> _checkEmulator() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      EmulatorGuard detector;

      if (_useCustomMethods) {
        // Create EmulatorGuard with custom methods
        detector = EmulatorGuard(
          androidMethods: [CustomDeviceNameMethod(), CustomHardwareMethod()],
          iosMethods: [CustomDeviceNameMethod()],
          androidThreshold: 50, // Lower threshold for demo
          iosThreshold: 50,
        );
      } else {
        // Use default methods
        detector = EmulatorGuard();
      }

      final result = await detector.detect();

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emulator Guard Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Emulator Detection Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detection Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _useCustomMethods
                                  ? 'Using Custom Methods (Device Name + Hardware Check)'
                                  : 'Using Default Methods (25+ Detection Methods)',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Switch(
                            value: _useCustomMethods,
                            onChanged: (value) {
                              setState(() {
                                _useCustomMethods = value;
                                _result = null; // Clear previous results
                              });
                            },
                          ),
                        ],
                      ),
                      if (_useCustomMethods) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Custom methods demonstrate how to create your own detection logic.',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _checkEmulator,
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text('Checking...'),
                        ],
                      )
                    : const Text('Check if Device is Emulator'),
              ),
              const SizedBox(height: 20),
              if (_error.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(
                    'Error: $_error',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              if (_result != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _result!.isEmulator
                                  ? Icons.warning
                                  : Icons.check_circle,
                              color: _result!.isEmulator
                                  ? Colors.orange
                                  : Colors.green,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _result!.isEmulator
                                    ? 'Emulator Detected'
                                    : 'Physical Device',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Emulator Score',
                          '${_result!.score.toStringAsFixed(1)}/100',
                        ),
                        _buildInfoRow(
                          'Is Emulator Device',
                          _result!.isEmulator.toString(),
                        ),
                        if (_result!.reasons.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Detection Reasons:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ..._result!.reasons.map(
                            (reason) => Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                bottom: 4,
                              ),
                              child: Text('• $reason'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Emulator Guard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'EmulatorGuard is a comprehensive Flutter package for detecting emulators and simulators across multiple platforms. It uses multiple detection methods and provides a scoring system to determine the likelihood that a device is an emulator.',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Features:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '• Multi-platform support (Android, iOS, Linux, macOS, Windows)',
                      ),
                      Text('• 25+ detection methods for Android alone'),
                      Text('• Configurable thresholds'),
                      Text('• Detailed reporting with reasons'),
                      Text('• Async file operations for better performance'),
                      Text(
                        '• Custom method support - create your own detection logic',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Custom Methods Example:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('This demo includes two custom methods:'),
                      Text(
                        '• CustomDeviceNameMethod: Checks for suspicious device names',
                      ),
                      Text(
                        '• CustomHardwareMethod: Analyzes hardware characteristics for emulator patterns',
                      ),
                      Text(
                        'Toggle the switch above to see how custom methods work!',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: label == 'Is Emulator Device'
                    ? (_result!.isEmulator ? Colors.green : Colors.orange)
                    : null,
                fontWeight: label == 'Is Emulator Device'
                    ? FontWeight.bold
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
