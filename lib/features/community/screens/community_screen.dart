import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateModTools() {
      Routemaster.of(context).push('/mod-tool');
    }

    final user = ref.watch(userProvider);
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
                            data.mods.contains(user!.uid)
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
                                    onPressed: () {},
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
                body: const Text('Displaying data'));
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
