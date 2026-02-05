import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String _permissionStatus = 'Not requested';

  void _requestCameraPermission() {
    // Simulating permission request
    // In a real app, you would use permission_handler package
    setState(() {
      _permissionStatus = 'Permission requested...';
    });

    // Simulate async permission dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _permissionStatus = 'Permission granted';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Permission Test'),
        leading: Semantics(
          identifier: 'camera_back_button',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 24),
            Text(
              'Permission Status:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Semantics(
              identifier: 'camera_permission_status',
              child: Text(
                _permissionStatus,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _permissionStatus == 'Permission granted'
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Semantics(
              identifier: 'camera_request_permission_button',
              child: ElevatedButton.icon(
                onPressed: _requestCameraPermission,
                icon: const Icon(Icons.camera),
                label: const Text('Request Camera Permission'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
