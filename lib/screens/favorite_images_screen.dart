import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/provider/favorite_images_provider.dart';
import 'package:imge_search_app/provider/image_search_provider.dart';
import 'package:imge_search_app/screens/image_preview.dart'; // 경로를 실제 파일 경로로 변경하세요

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<FavoriteScreen> {
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
    final favoriteImagesList = ref.watch(favoriteImagesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Favorite Images'),
        ),
        scrolledUnderElevation: 0,
      ),
      body: favoriteImagesList.isEmpty
          ? const Center(
              child: Text('No favorite images.'),
            )
          : MasonryGridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: favoriteImagesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewScreen(
                            imageUrl: favoriteImagesList[index]),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: CachedNetworkImage(
                          imageUrl: favoriteImagesList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (ref
                              .watch(favoriteImagesProvider)
                              .contains(favoriteImagesList[index])) {
                            ref
                                .read(favoriteImagesProvider.notifier)
                                .removeFavoriteImage(favoriteImagesList[index]);
                          } else {
                            ref
                                .read(favoriteImagesProvider.notifier)
                                .saveFavoriteImage(favoriteImagesList[index]);
                          }
                        },
                        icon: Icon(
                          ref
                                  .watch(favoriteImagesProvider)
                                  .contains(favoriteImagesList[index])
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: ref
                                  .watch(favoriteImagesProvider)
                                  .contains(favoriteImagesList[index])
                              ? sZSBlue
                              : grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
