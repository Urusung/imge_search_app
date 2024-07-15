import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';
import 'package:imge_search_app/provider/imageSearchTextField_provider.dart';
import 'package:imge_search_app/provider/images_search_provider.dart';
import 'package:imge_search_app/provider/recent_search_words_provider.dart';
import 'package:imge_search_app/screens/image_search_screen.dart/no_search_image_container_widget.dart';
import 'package:imge_search_app/screens/image_search_screen.dart/recent_search_words_list_widget.dart';
import 'package:imge_search_app/screens/image_search_screen.dart/search_images_column_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final imagesSearchList = ref.watch(imagesSearchProvider);
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
          ? RecentSearchWordsListWidget(
              imagesSearchTextFieldFocusNode: imagesSearchTextFieldFocusNode,
              imagesSearchTextFieldController: imagesSearchTextFieldController,
            )
          : imagesSearchList.when(
              data: (data) {
                if (data.isEmpty) {
                  return NoSearchImageContainerWidget(
                      imagesSearchTextFieldController:
                          imagesSearchTextFieldController);
                }
                return SearchImagesColumnWidget(
                    data: data,
                    imagesSearchTextFieldController:
                        imagesSearchTextFieldController,
                    imageSearchListScrollController:
                        imageSearchListScrollController);
              },
              loading: () => RecentSearchWordsListWidget(
                imagesSearchTextFieldFocusNode: imagesSearchTextFieldFocusNode,
                imagesSearchTextFieldController:
                    imagesSearchTextFieldController,
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
    );
  }

  TextField imagesSearchTextField() {
    return TextField(
      focusNode: imagesSearchTextFieldFocusNode,
      controller: imagesSearchTextFieldController,
      style: appBarStyle,
      decoration: InputDecoration(
        hintText: 'Search for images',
        hintStyle: appBarStyle.copyWith(color: grey),
        prefixIcon: const Icon(Icons.search_rounded, color: mainColor),
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
          borderSide: const BorderSide(color: mainColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36.0),
          borderSide: const BorderSide(color: mainColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36.0),
          borderSide: const BorderSide(color: mainColor, width: 2.0),
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
}
