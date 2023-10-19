// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

import 'package:reddit/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int crt = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(
          context,
          uids.toList(),
          widget.name,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, int index) {
                final member = community.members[index];
                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && crt == 0) {
                          uids.add(member);
                        }
                        crt++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              }),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
