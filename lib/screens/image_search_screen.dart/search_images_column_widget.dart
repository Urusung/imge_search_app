import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';
import 'package:imge_search_app/model/image_model.dart';
import 'package:imge_search_app/provider/favorite_images_provider.dart';
import 'package:imge_search_app/provider/images_search_provider.dart';
import 'package:imge_search_app/screens/image_preview.dart';
import 'package:imge_search_app/screens/no_title_alert_dialog_widget.dart';

class SearchImagesColumnWidget extends ConsumerWidget {
  const SearchImagesColumnWidget({
    super.key,
    required this.data,
    required this.imagesSearchTextFieldController,
    required this.imageSearchListScrollController,
  });

  final List<ImageModel> data;
  final TextEditingController imagesSearchTextFieldController;
  final ScrollController imageSearchListScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(top: 8.0),
          color: white,
          child: Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ref.watch(sortTypeProvider) == 'accuracy'
                        ? mainColor
                        : grey,
                    radius: 4.0,
                  ),
                  const Gap(12),
                  GestureDetector(
                    onTap: () {
                      ref.read(imagesSearchProvider.notifier).searchImage(
                          imagesSearchTextFieldController.text, 'accuracy');
                      ref
                          .read(sortTypeProvider.notifier)
                          .update((state) => 'accuracy');
                    },
                    child: Text(
                      'Accuracy',
                      style: sortTypeStyle.copyWith(
                        color: ref.watch(sortTypeProvider) == 'accuracy'
                            ? black
                            : grey,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ref.watch(sortTypeProvider) == 'recency'
                        ? mainColor
                        : grey,
                    radius: 4.0,
                  ),
                  const Gap(12),
                  GestureDetector(
                    onTap: () {
                      ref.read(imagesSearchProvider.notifier).searchImage(
                          imagesSearchTextFieldController.text, 'recency');
                      ref
                          .read(sortTypeProvider.notifier)
                          .update((state) => 'recency');
                    },
                    child: Text(
                      'Recency',
                      style: sortTypeStyle.copyWith(
                        color: ref.watch(sortTypeProvider) == 'recency'
                            ? black
                            : grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
            color: white,
            child: MasonryGridView.count(
              controller: imageSearchListScrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: data.length,
              itemBuilder: (context, index) {
                int? statusCode;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ImagePreviewScreen(
                            imageUrl: statusCode == 404
                                ? data[index].thumbnailUrl
                                : data[index].imageUrl,
                          );
                        },
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: grey, width: 0.2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CachedNetworkImage(
                                imageUrl: data[index].imageUrl,
                                errorWidget: (context, url, error) {
                                  statusCode = int.tryParse(RegExp(r'\d{3}')
                                          .firstMatch(error.toString())
                                          ?.group(0) ??
                                      '');
                                  if (statusCode == 404) {
                                    return Center(
                                      child: CachedNetworkImage(
                                          imageUrl: data[index].thumbnailUrl),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                                fit: BoxFit.contain,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (statusCode == 404) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return NoTitleAlertDialogWidget(
                                              isOneButton: true,
                                              contentText:
                                                  'Image does not exist.',
                                              okButtonOnPressed: () {
                                                Navigator.pop(context);
                                              },
                                              cancelButtonOnPressed: () {});
                                        });
                                  } else {
                                    if (ref
                                        .watch(favoriteImagesProvider)
                                        .contains(data[index].imageUrl)) {
                                      ref
                                          .read(favoriteImagesProvider.notifier)
                                          .removeFavoriteImage(
                                              data[index].imageUrl);
                                    } else {
                                      ref
                                          .read(favoriteImagesProvider.notifier)
                                          .saveFavoriteImage(
                                              data[index].imageUrl);
                                    }
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
                                      ? mainColor
                                      : grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        data[index].displaySitename,
                        style: displaySitenameStyle,
                      ),
                      const Gap(4),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
