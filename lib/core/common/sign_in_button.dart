// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({
    super.key,
    required this.isFromLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void signInWithGoogle(BuildContext context, WidgetRef ref) {
      ref
          .read(authControllerProvider.notifier)
          .signInWithGoogle(context, isFromLogin);
    }

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () {
          signInWithGoogle(context, ref);
        },
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
