import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';
import 'package:imge_search_app/provider/favorite_images_provider.dart';
import 'package:imge_search_app/provider/imageSearchTextField_provider.dart';
import 'package:imge_search_app/provider/images_search_provider.dart';
import 'package:imge_search_app/provider/recent_search_words_provider.dart';
import 'package:imge_search_app/screens/image_preview.dart';

class ImagesSearchScreen extends ConsumerStatefulWidget {
  const ImagesSearchScreen({super.key});

  @override
  ConsumerState<ImagesSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<ImagesSearchScreen> {
  final TextEditingController imagesSearchTextFieldController =
      TextEditingController();
  final ScrollController imageSearchListScrollController = ScrollController();
  final FocusNode imagesSearchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    imageSearchListScrollController.addListener(_onScroll);
    imagesSearchTextFieldController.addListener(
      () {
        ref.read(imagesSearchTextFieldControllerTextProvider.notifier).update(
          (state) {
            return imagesSearchTextFieldController.text;
          },
        );
      },
    );
    imagesSearchTextFieldFocusNode.addListener(
      () {
        ref.read(isImagesSearchTextFieldFocusedProvider.notifier).update(
          (state) {
            return imagesSearchTextFieldFocusNode.hasFocus;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    imagesSearchTextFieldController.dispose();
    imageSearchListScrollController.dispose();
    imagesSearchTextFieldFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (imageSearchListScrollController.position.pixels >=
        imageSearchListScrollController.position.maxScrollExtent - 200) {
      ref.read(imagesSearchProvider.notifier).fetchMoreImages('accuracy');
    }
  }

  TextField imagesSearchTextField() {
    return TextField(
      focusNode: imagesSearchTextFieldFocusNode,
      controller: imagesSearchTextFieldController,
      style: appBarStyle,
      decoration: InputDecoration(
        hintText: 'Search for images',
        hintStyle: appBarStyle.copyWith(color: grey),
        prefixIcon: const Icon(Icons.search_rounded, color: szsBlue),
        suffixIcon: Visibility(
          visible: ref.watch(imagesSearchTextFieldControllerTextProvider) == ''
              ? false
              : true,
          child: IconButton(
            icon: const Icon(Icons.clear, color: grey),
            onPressed: () {
              FocusScope.of(context)
                  .requestFocus(imagesSearchTextFieldFocusNode);
              ref.invalidate(imagesSearchProvider);
              imagesSearchTextFieldController.clear();
            },
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36.0),
          borderSide: const BorderSide(color: szsBlue, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36.0),
          borderSide: const BorderSide(color: szsBlue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36.0),
          borderSide: const BorderSide(color: szsBlue, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      ),
      onSubmitted: (value) {
        ref.read(imagesSearchProvider.notifier).searchImage(value, 'accuracy');
        ref.read(sortTypeProvider.notifier).update((state) => 'accuracy');
        ref
            .read(recentSearchWordsProvider.notifier)
            .saveRecentSearchWords(value, DateTime.now());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesSearchList = ref.watch(imagesSearchProvider);
    final recentSearchWordsList = ref.watch(recentSearchWordsProvider);
    final isImagesSearchTextFieldFocused =
        ref.watch(isImagesSearchTextFieldFocusedProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 12,
        backgroundColor: white,
        title: imagesSearchTextField(),
        scrolledUnderElevation: 0,
      ),
      body: isImagesSearchTextFieldFocused
          ? Container(
              decoration: BoxDecoration(
                color: white,
                border: Border(
                  bottom: BorderSide(
                    color: grey.withOpacity(0.2),
                    width: 2.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentSearchWordsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 28.0,
                              height: 28.0,
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: black,
                                size: 18.0,
                              ),
                            ),
                            const Gap(12),
                            GestureDetector(
                              onTap: () {
                                imagesSearchTextFieldFocusNode.unfocus();
                                imagesSearchTextFieldController.text =
                                    recentSearchWordsList[index]
                                        .recentSearchWord;
                                ref
                                    .read(imagesSearchProvider.notifier)
                                    .searchImage(
                                        recentSearchWordsList[index]
                                            .recentSearchWord,
                                        'accuracy');
                                ref
                                    .read(sortTypeProvider.notifier)
                                    .update((state) => 'accuracy');
                                ref
                                    .read(recentSearchWordsProvider.notifier)
                                    .saveRecentSearchWords(
                                      recentSearchWordsList[index]
                                          .recentSearchWord,
                                      DateTime.now(),
                                    );
                              },
                              child: Text(
                                recentSearchWordsList[index].recentSearchWord,
                                style: recentSearchWordStyle,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${recentSearchWordsList[index].dateTime.month.toString().padLeft(2, '0')}.${recentSearchWordsList[index].dateTime.day.toString().padLeft(2, '0')}.',
                              style: recentSearchWordDateTimeStyle,
                            ),
                            const Gap(12.0),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(recentSearchWordsProvider.notifier)
                                    .removeRecentSearchWord(
                                        recentSearchWordsList[index]
                                            .recentSearchWord);
                              },
                              child: const Icon(
                                Icons.clear_rounded,
                                color: grey,
                                size: 18.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    width: MediaQuery.of(context).size.width - 24,
                    height: 1.0,
                    color: backgroundColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Turn off recent seach words',
                            style: recentSearchWordDateTimeStyle,
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          width: 1.0,
                          height: 15,
                          color: backgroundColor,
                        ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(recentSearchWordsProvider.notifier)
                                .removeAllRecentSearchWords();
                          },
                          child: const Text(
                            'Delete all',
                            style: recentSearchWordDateTimeStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12.0),
                ],
              ),
            )
          : imagesSearchList.when(
              data: (data) {
                if (data.isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(top: 8.0),
                    color: white,
                    child: Text.rich(
                      TextSpan(
                        text: 'No search images for ',
                        style: imageNotFoundStyle,
                        children: [
                          TextSpan(
                            text: imagesSearchTextFieldController.text.length >
                                    27
                                ? "'${imagesSearchTextFieldController.text.substring(0, 27)}...'"
                                : "'${imagesSearchTextFieldController.text}'",
                            style: imageNotFoundStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: red,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }
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
                                backgroundColor:
                                    ref.watch(sortTypeProvider) == 'accuracy'
                                        ? szsBlue
                                        : grey,
                                radius: 4.0,
                              ),
                              const Gap(12),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(imagesSearchProvider.notifier)
                                      .searchImage(
                                          imagesSearchTextFieldController.text,
                                          'accuracy');
                                  ref
                                      .read(sortTypeProvider.notifier)
                                      .update((state) => 'accuracy');
                                },
                                child: Text(
                                  'Accuracy',
                                  style: sortTypeStyle.copyWith(
                                    color: ref.watch(sortTypeProvider) ==
                                            'accuracy'
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
                                backgroundColor:
                                    ref.watch(sortTypeProvider) == 'recency'
                                        ? szsBlue
                                        : grey,
                                radius: 4.0,
                              ),
                              const Gap(12),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(imagesSearchProvider.notifier)
                                      .searchImage(
                                          imagesSearchTextFieldController.text,
                                          'recency');
                                  ref
                                      .read(sortTypeProvider.notifier)
                                      .update((state) => 'recency');
                                },
                                child: Text(
                                  'Recency',
                                  style: sortTypeStyle.copyWith(
                                    color:
                                        ref.watch(sortTypeProvider) == 'recency'
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
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 12.0),
                        color: white,
                        child: MasonryGridView.count(
                          controller: imageSearchListScrollController,
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
                                    builder: (context) => ImagePreviewScreen(
                                        imageUrl: data[index].imageUrl),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              color: grey, width: 0.2),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: CachedNetworkImage(
                                            imageUrl: data[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (ref
                                              .watch(favoriteImagesProvider)
                                              .contains(data[index].imageUrl)) {
                                            ref
                                                .read(favoriteImagesProvider
                                                    .notifier)
                                                .removeFavoriteImage(
                                                    data[index].imageUrl);
                                          } else {
                                            ref
                                                .read(favoriteImagesProvider
                                                    .notifier)
                                                .saveFavoriteImage(
                                                    data[index].imageUrl);
                                          }
                                        },
                                        icon: Icon(
                                          ref
                                                  .watch(favoriteImagesProvider)
                                                  .contains(
                                                      data[index].imageUrl)
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          color: ref
                                                  .watch(favoriteImagesProvider)
                                                  .contains(
                                                      data[index].imageUrl)
                                              ? szsBlue
                                              : grey,
                                        ),
                                      ),
                                    ],
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
              },
              loading: () => Container(
                decoration: BoxDecoration(
                  color: white,
                  border: Border(
                    bottom: BorderSide(
                      color: grey.withOpacity(0.2),
                      width: 2.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: recentSearchWordsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 28.0,
                                height: 28.0,
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: const Icon(
                                  Icons.access_time_rounded,
                                  color: black,
                                  size: 18.0,
                                ),
                              ),
                              const Gap(12),
                              GestureDetector(
                                onTap: () {
                                  imagesSearchTextFieldFocusNode.unfocus();
                                  imagesSearchTextFieldController.text =
                                      recentSearchWordsList[index]
                                          .recentSearchWord;
                                  ref
                                      .read(imagesSearchProvider.notifier)
                                      .searchImage(
                                          recentSearchWordsList[index]
                                              .recentSearchWord,
                                          'accuracy');
                                  ref
                                      .read(sortTypeProvider.notifier)
                                      .update((state) => 'accuracy');
                                  ref
                                      .read(recentSearchWordsProvider.notifier)
                                      .saveRecentSearchWords(
                                        recentSearchWordsList[index]
                                            .recentSearchWord,
                                        DateTime.now(),
                                      );
                                },
                                child: Text(
                                  recentSearchWordsList[index].recentSearchWord,
                                  style: recentSearchWordStyle,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${recentSearchWordsList[index].dateTime.month.toString().padLeft(2, '0')}.${recentSearchWordsList[index].dateTime.day.toString().padLeft(2, '0')}.',
                                style: recentSearchWordDateTimeStyle,
                              ),
                              const Gap(12.0),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(recentSearchWordsProvider.notifier)
                                      .removeRecentSearchWord(
                                          recentSearchWordsList[index]
                                              .recentSearchWord);
                                },
                                child: const Icon(
                                  Icons.clear_rounded,
                                  color: grey,
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      width: MediaQuery.of(context).size.width - 24,
                      height: 1.0,
                      color: backgroundColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Turn off recent seach words',
                              style: recentSearchWordDateTimeStyle,
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            width: 1.0,
                            height: 15,
                            color: backgroundColor,
                          ),
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(recentSearchWordsProvider.notifier)
                                  .removeAllRecentSearchWords();
                            },
                            child: const Text(
                              'Delete all',
                              style: recentSearchWordDateTimeStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(12.0),
                  ],
                ),
              ),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
    );
  }
}
