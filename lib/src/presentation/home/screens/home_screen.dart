import 'package:flutter/material.dart';
import 'package:tax_collect/src/presentation/contribuable/contribuable.dart';
import 'package:tax_collect/src/presentation/profile/profile.dart';
import 'package:tax_collect/src/presentation/tax_collect/screens/screens.dart';
import 'package:tax_collect/src/widgets/session_observer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final List<String> _titles = [
    "Dashboard",
    "Collectes",
    "Contribuables",
    "Profil",
  ];
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SessionObserver(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentScreenIndex]),
          centerTitle: true,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (_currentScreenIndex != index) {
              _currentScreenIndex = index;
              setState(() {});
            }
          },
          children: [TaxCollectScreen(), ContribuableScreen(), ProfileScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            //BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: "Collectes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Contribuables",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
          currentIndex: _currentScreenIndex,
          onTap: (index) {
            _updatePageIndex(index);
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  void _updatePageIndex(int index) {
    if (_currentScreenIndex != index) {
      _currentScreenIndex = index;
      _pageController.jumpToPage(_currentScreenIndex);
      setState(() {});
    }
  }
}
