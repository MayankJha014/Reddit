import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';
import 'package:reddit/model/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    try {
      state = true;
      final user = await _authRepository.signWithGoogle(isFromLogin);
      user.fold(
          (l) => showSnackBar(context, l.message),
          (userModel) =>
              _ref.read(userProvider.notifier).update((state) => userModel));
    } catch (e) {
      showSnackBar(context, "An error occurred: $e");
    } finally {
      state = false;
    }
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logout() {
    _authRepository.logout();
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
