// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/home/delagates/search_community_delegate.dart';
import 'package:reddit/features/home/drawers/community_list_drawer.dart';
import 'package:reddit/features/home/drawers/profile_drawer.dart';
import 'package:reddit/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProfider);
    return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }),
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchCommunityDelegate(ref: ref));
              },
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            })
          ],
        ),
        drawer: const CommunityListDrawer(),
        endDrawer: isGuest ? null : const ProfileDrawer(),
        bottomNavigationBar: isGuest
            ? null
            : CupertinoTabBar(
                activeColor: currentTheme.iconTheme.color,
                backgroundColor: currentTheme.backgroundColor,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 25,
                    ),
                    // label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                      size: 25,
                    ),
                    // label: '',
                  ),
                ],
                onTap: onPageChanged,
                currentIndex: _page,
              ),
        body: Constants.tabWidget[_page]);
  }
}
