import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_screen_pages/activities/activities_screen.dart';
import 'home_screen_pages/history/history_screen.dart';
import 'home_screen_pages/settings/settings_screen.dart';

final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    ActivitiesScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      key: homeScaffoldKey,
      body: _pages[_currentIndex],
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.8,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black45.withValues(alpha: 0.6),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                colorFilter: ColorFilter.mode(_currentIndex == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6), BlendMode.srcIn),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/history.svg',
                colorFilter: ColorFilter.mode(_currentIndex == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6), BlendMode.srcIn),
              ),
              label: 'History'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/setting.svg',
              colorFilter: ColorFilter.mode(_currentIndex == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6), BlendMode.srcIn),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
