import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateProfile(context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void toggleTheme() {
      ref.read(themeNotifierProfider.notifier).toggleTheme();
    }

    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
              user.profilePic,
            ),
            radius: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'u/${user.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              navigateProfile(context, user.uid);
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            onTap: () => logOut(ref),
          ),
          Switch.adaptive(
              value: ref.watch(themeNotifierProfider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (value) {
                toggleTheme();
              })
        ],
      )),
    );
  }
}
