import 'package:flutter/material.dart';

import '../../UI Helper/colors.dart';
import '../../main.dart';
import 'Favourite/faviourate_screen.dart';
import 'Home Screens/Drawer/dietpreference.dart';
import 'Home Screens/Drawer/health_dashboard.dart';
import 'Home Screens/home_screen.dart';
import 'Profile/profile_screen.dart';
import 'Scan Screen/scan_screen.dart';
import 'Scans History/history_screen.dart';
import 'navbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0; // Dashboard is Selected by default

  late final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    ScanScreen(),
    // ScanProductScreen(),
    HistoryScreen(),
    FaviourateScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      body: _screens[_selectedIndex],
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('Health Dashboard'),
              onTap: () {
                Navigator.of(context).pop();
                navigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (_) => const HealthDashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('Dietary Preferences'),
              onTap: () {
                Navigator.of(context).pop();
                navigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (_) => const DietPreference()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
