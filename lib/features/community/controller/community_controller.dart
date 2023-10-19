import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/storage_repository.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/repository/community_repository.dart';
import 'package:reddit/model/community_model.dart';
import 'package:reddit/model/post_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider((ref) {
  final communities = ref.watch(communityControllerProvider.notifier);
  return communities.getUserCommunities();
});
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communities = ref.watch(communityControllerProvider.notifier);
  return communities.getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  final communities = ref.watch(communityControllerProvider.notifier);
  return communities.searchCommunity(query);
});

final communityPostProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    storageRepository: storageRepository,
    communityRepository: communityRepository,
    ref: ref,
  );
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community Create Successfully');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(BuildContext context, Community community) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, 'Community left successfullly!');
      } else {
        showSnackBar(context, 'Community joined successfullly!');
      }
    });
  }

  void addMods(
      BuildContext context, List<String> uids, String communityName) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.toString()),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void editCommunity({
    required File? profileImage,
    required File? bannerImage,
    required Community community,
    required BuildContext context,
  }) async {
    if (profileImage != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.id,
        file: profileImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.toString()),
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerImage != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.id,
        file: bannerImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.toString()),
        (r) => community = community.copyWith(banner: r),
      );
    }
    final res = await _communityRepository.editCommunity(community);

    res.fold(
      (l) => showSnackBar(context, l.toString()),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
