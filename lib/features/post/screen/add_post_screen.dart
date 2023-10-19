import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 100;
    double iconSize = 30;
    final currentTheme = ref.watch(themeNotifierProfider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            navigateToType(context, 'image');
          },
          child: SizedBox(
            width: cardHeightWidth,
            height: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              // ignore: deprecated_member_use
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            navigateToType(context, 'text');
          },
          child: SizedBox(
            width: cardHeightWidth,
            height: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              // ignore: deprecated_member_use
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.font_download,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            navigateToType(context, 'link');
          },
          child: SizedBox(
            width: cardHeightWidth,
            height: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              // ignore: deprecated_member_use
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
