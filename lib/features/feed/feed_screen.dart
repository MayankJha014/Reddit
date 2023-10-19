import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/model/community_model.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
          data: (communities) => ref.watch(userPostsProvider(communities)).when(
                data: (data) {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, int index) {
                        final post = data[index];
                        return PostCard(post: post);
                      });
                },
                error: (error, stackTrace) {
                  print(error);
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
