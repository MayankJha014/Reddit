import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/model/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateModTools() {
      Routemaster.of(context).push('/mod-tool/$name');
    }

    void joinCommunity(WidgetRef ref, Community community) {
      ref
          .read(communityControllerProvider.notifier)
          .joinCommunity(context, community);
    }

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (data) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(children: [
                      Positioned.fill(
                          child: Image.network(
                        data.banner,
                        fit: BoxFit.cover,
                      ))
                    ]),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(data.avatar),
                          radius: 35,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${data.name}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isGuest)
                            data.mods.contains(user.uid)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      ),
                                    ),
                                    onPressed: () {
                                      navigateModTools();
                                    },
                                    child: const Text('Mod Tools'),
                                  )
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      ),
                                    ),
                                    onPressed: () {
                                      joinCommunity(ref, data);
                                    },
                                    child: Text(
                                      data.members.contains(user.uid)
                                          ? 'Joined'
                                          : 'Join',
                                    ),
                                  )
                        ],
                      ),
                      Text(
                        '${data.members.length} members',
                      )
                    ])),
                  )
                ];
              },
              body: ref.watch(communityPostProvider(name)).when(
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
          loading: () => const Loader()),
    );
  }
}
