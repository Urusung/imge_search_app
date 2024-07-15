import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';
import 'package:imge_search_app/provider/favorite_images_provider.dart';
import 'package:imge_search_app/screens/image_preview.dart';

class FavoriteImagesScreen extends ConsumerWidget {
  const FavoriteImagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteImagesList = ref.watch(favoriteImagesProvider);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: const Text(
          'Favorite Images',
          style: appBarStyle,
        ),
        scrolledUnderElevation: 0,
      ),
      body: favoriteImagesList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 92,
                    color: grey,
                  ),
                  Text(
                    'Favorite Images is Empty',
                    style: favoriteImageNotFoundStyle,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
              child: MasonryGridView.count(
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: grey, width: 0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: favoriteImagesList[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (ref
                                .watch(favoriteImagesProvider)
                                .contains(favoriteImagesList[index])) {
                              ref
                                  .read(favoriteImagesProvider.notifier)
                                  .removeFavoriteImage(
                                      favoriteImagesList[index]);
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
                                ? mainColor
                                : grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
