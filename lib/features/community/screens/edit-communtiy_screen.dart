// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/model/community_model.dart';

class EditCommuntiyScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommuntiyScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommuntiyScreenState();
}

class _EditCommuntiyScreenState extends ConsumerState<EditCommuntiyScreen> {
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) async {
    ref.read(communityControllerProvider.notifier).editCommunity(
        profileImage: profileFile,
        bannerImage: bannerFile,
        community: community,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Edit Community',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    save(community);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: selectBannerImage,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2.5,
                                      ),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault
                                            ? const Icon(
                                                Icons.camera_alt_outlined,
                                              )
                                            : Image.network(community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 25,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                FileImage(profileFile!),
                                            radius: 20,
                                          )
                                        : const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                Constants.avatarDefault),
                                            radius: 20,
                                          ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
