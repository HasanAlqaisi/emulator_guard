import 'package:flutter/material.dart';
import 'package:emulator_guard/emulator_guard.dart';

void main() {
  runApp(const MyApp());
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

  Future<void> _checkEmulator() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final detector = EmulatorGuard();
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
