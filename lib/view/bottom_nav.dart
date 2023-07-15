import 'dart:developer';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/Api/api.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/view/admin_home.dart';
import 'package:taxverse_admin/view/chat/chat.dart';
import 'package:taxverse_admin/view/newslist.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with WidgetsBindingObserver {
  int index = 0;

  final screen = [
    HomeAdmin(),
    NewsListTile(),
    ChatList(),
  ];

  @override
  void initState() {
    super.initState();

    APIs.getDocumetID().then((value) {
      WidgetsBinding.instance.addObserver(this);

      APIs.updateActiveStatus(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log('resumed');
      APIs.updateActiveStatus(true);
    } else {
      log('paused');
      APIs.updateActiveStatus(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: screen[index],
        bottomNavigationBar: CurvedNavigationBar(
          color: blackColor,
          buttonBackgroundColor: blackColor,
          animationCurve: Curves.linear,
          height: 60,
          backgroundColor: Colors.white,

          index: index,
          // buttonBackgroundColor: Colors.black,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
          items: const [
            Icon(
              Icons.home,
              size: 35,
              color: Colors.white,
            ),
            Icon(
              Icons.chat,
              size: 35,
              color: Colors.white,
            ),
            Icon(
              Icons.newspaper_outlined,
              size: 35,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
