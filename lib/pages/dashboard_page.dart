import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Semantics(
            identifier: 'dashboard_logout_button',
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    identifier: 'dashboard_profile_card',
                    icon: Icons.person,
                    title: 'Profile',
                    color: Colors.blue,
                  ),
                  _buildDashboardCard(
                    context,
                    identifier: 'dashboard_settings_card',
                    icon: Icons.settings,
                    title: 'Settings',
                    color: Colors.grey,
                  ),
                  _buildDashboardCard(
                    context,
                    identifier: 'dashboard_analytics_card',
                    icon: Icons.analytics,
                    title: 'Analytics',
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    context,
                    identifier: 'dashboard_notifications_card',
                    icon: Icons.notifications,
                    title: 'Notifications',
                    color: Colors.orange,
                  ),
                  _buildNavigableDashboardCard(
                    context,
                    identifier: 'dashboard_camera_card',
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    color: Colors.deepPurple,
                    route: '/camera',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Semantics(
        identifier: 'dashboard_add_button',
        child: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Add new item')));
          },
          child: const Icon(Icons.add, semanticLabel: 'Add'),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String identifier,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Semantics(
      identifier: identifier,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$title tapped')));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigableDashboardCard(
    BuildContext context, {
    required String identifier,
    required IconData icon,
    required String title,
    required Color color,
    required String route,
  }) {
    return Semantics(
      identifier: identifier,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
