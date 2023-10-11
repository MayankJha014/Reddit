import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final TextEditingController createCommunityController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    createCommunityController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(createCommunityController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a community"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Community name'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: createCommunityController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'r/Community_name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    keyboardAppearance: Brightness.light,
                    maxLength: 21,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createCommunity();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Create Community',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
