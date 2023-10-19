// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateEditProfile(context, String uid) {
      Routemaster.of(context).push('/edit-profile/$uid');
    }

    // final user = ref.read(userProvider);
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 250,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 45,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                            ),
                            onPressed: () {
                              navigateEditProfile(context, uid);
                            },
                            child: const Text('Edit Profile'),
                          ),
                        )
                      ]),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${user.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${user.karma} karma',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: ref.watch(getuserPost(uid)).when(
                      data: (data) {
                        return ListView.builder(
                          itemBuilder: (context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                          itemCount: data.length,
                        );
                      },
                      error: (error, stackTrace) {
                        print(error);
                        return ErrorText(error: error.toString());
                      },
                      loading: () => const Loader(),
                    ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
