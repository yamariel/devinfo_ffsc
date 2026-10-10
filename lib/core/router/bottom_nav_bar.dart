import 'package:flutter/material.dart';

import '../../features/news/presentation/pages/home_page.dart';
import '../../features/news/presentation/pages/profile_page.dart';
import '../../features/videos/presentation/views/video_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
  
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const VideoPage(),
    const ProfilePage(),
  ];

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: 'Article',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_chat),
      label: 'Article en vidéo',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _items,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
