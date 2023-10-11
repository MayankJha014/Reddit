import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModToolsScreen extends ConsumerWidget {
  const ModToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Moderators'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
