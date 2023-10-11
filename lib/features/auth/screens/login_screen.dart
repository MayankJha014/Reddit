import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/sign_in_button.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            Constants.logoPath,
            fit: BoxFit.contain,
            height: 40,
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ]),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Dive into anything",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.loginEmotePath,
                    height: 400,
                  ),
                ),
                const SignInButton()
              ],
            ),
    );
  }
}