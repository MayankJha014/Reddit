// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profileImage: profileFile,
          bannerImage: bannerFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProfider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Edit Community',
              ),
              actions: [
                TextButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
              ],
            ),
            body: Padding(
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
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.5,
                                ),
                              ),
                              child: bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : user.banner.isEmpty ||
                                          user.banner == Constants.bannerDefault
                                      ? const Icon(
                                          Icons.camera_alt_outlined,
                                        )
                                      : Image.network(user.banner),
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
                                      backgroundImage: FileImage(profileFile!),
                                      radius: 20,
                                    )
                                  : const CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(Constants.avatarDefault),
                                      radius: 20,
                                    ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                      ),
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
