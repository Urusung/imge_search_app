import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/provider/favorite_images_provider.dart';
import 'package:imge_search_app/provider/image_search_provider.dart';
import 'package:imge_search_app/screens/image_preview.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(imageSearchProvider.notifier).fetchMoreImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagesSearchList = ref.watch(imageSearchProvider);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search for images',
            prefixIcon: const Icon(Icons.search_rounded, color: sZSBlue),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: grey),
              onPressed: () {
                _controller.clear();
              },
            ),
            filled: true,
            fillColor: white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: sZSBlue, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: sZSBlue, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: sZSBlue, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 18.0),
          ),
          onSubmitted: (value) {
            ref.read(imageSearchProvider.notifier).searchImage(value);
          },
        ),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
        child: imagesSearchList.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('No images found.'));
            }
            return MasonryGridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImagePreviewScreen(imageUrl: data[index].imageUrl),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: data[index].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (ref
                                  .watch(favoriteImagesProvider)
                                  .contains(data[index].imageUrl)) {
                                ref
                                    .read(favoriteImagesProvider.notifier)
                                    .removeFavoriteImage(data[index].imageUrl);
                              } else {
                                ref
                                    .read(favoriteImagesProvider.notifier)
                                    .saveFavoriteImage(data[index].imageUrl);
                              }
                            },
                            icon: Icon(
                              ref
                                      .watch(favoriteImagesProvider)
                                      .contains(data[index].imageUrl)
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: ref
                                      .watch(favoriteImagesProvider)
                                      .contains(data[index].imageUrl)
                                  ? sZSBlue
                                  : grey,
                            ),
                          ),
                        ],
                      ),
                      const Gap(4),
                      Text(data[index].displaySitename),
                      const Gap(4),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => Container(),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
