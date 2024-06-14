import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imge_search_app/seach_image_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              ref.read(searhImageProvider).whenData(
                (value) {
                  print(value);
                },
              );
            },
            child: const Text('Search'),
          ),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const Expanded(
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}
