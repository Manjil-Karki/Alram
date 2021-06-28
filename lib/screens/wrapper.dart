import 'package:alram/utilities/router.dart' as router;
// ignore: import_of_legacy_library_into_null_safe
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_navigatorKey.currentState!.canPop()) {
              _navigatorKey.currentState!.popUntil((route) => route.isFirst);
              if (_currentIndex != 0) {
                setState(() {
                  _currentIndex = 0;
                });
              }
              return false;
            }
            return true;
          },
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: router.generateRoute,
            initialRoute: 'wrapper/home',
            onUnknownRoute: null,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Navigator.pushNamed(context, 'add_alram');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.3,
        currentIndex: _currentIndex,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: true,
        backgroundColor: Theme.of(context).primaryColor,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home_filled,
            ),
            title: Text("Home"),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.task_alt,
            ),
            activeIcon: Icon(
              Icons.task_alt_outlined,
            ),
            title: Text("Challenges"),
          ),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.person_outline,
              ),
              activeIcon: Icon(
                Icons.person,
              ),
              title: Text("Profile"))
        ],
        onTap: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
            switch (index) {
              case 0:
                if (_navigatorKey.currentState!.canPop()) {
                  _navigatorKey.currentState!
                      .popUntil((route) => route.isFirst);
                }
                break;
              case 1:
                _navigatorKey.currentState!.pushNamed('wrapper/profile');
                break;
              default:
                _navigatorKey.currentState!.pushNamed('wrapper/home');
            }
          }
        },
      ),
    );
  }
}
