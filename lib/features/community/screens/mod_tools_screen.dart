// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateModTools() {
      Routemaster.of(context).push('/edit-community/$name');
    }

    void navigateAddModTools() {
      Routemaster.of(context).push('/add-mods/$name');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add Moderators'),
            onTap: navigateAddModTools,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: navigateModTools,
          ),
        ],
      ),
    );
  }
}
