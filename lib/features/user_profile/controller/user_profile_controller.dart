import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/providers/storage_repository.dart';
import 'package:reddit/enums/enums.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit/model/post_model.dart';
import 'package:reddit/model/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:reddit/core/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    storageRepository: storageRepository,
    userProfileRepository: userProfileRepository,
    ref: ref,
  );
});

final getuserPost = StreamProvider.family(
  (ref, String uid) =>
      ref.read(userProfileControllerProvider.notifier).getUserPosts(uid),
);

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editProfile({
    required File? profileImage,
    required File? bannerImage,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileImage != null) {
      final res = await _storageRepository.storeFile(
        path: 'user/profile',
        id: user.uid,
        file: profileImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.toString()),
        (r) => user = user.copyWith(profilePic: r),
      );
    }
    if (bannerImage != null) {
      final res = await _storageRepository.storeFile(
        path: 'user/banner',
        id: user.uid,
        file: bannerImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.toString()),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editCommunity(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.toString()),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }
}
