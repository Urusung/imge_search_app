import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';
import 'package:imge_search_app/provider/images_search_provider.dart';
import 'package:imge_search_app/provider/recent_search_words_provider.dart';
import 'package:imge_search_app/screens/no_title_alert_dialog_widget.dart';

class RecentSearchWordsListWidget extends ConsumerWidget {
  const RecentSearchWordsListWidget({
    super.key,
    required this.imagesSearchTextFieldFocusNode,
    required this.imagesSearchTextFieldController,
  });

  final FocusNode imagesSearchTextFieldFocusNode;
  final TextEditingController imagesSearchTextFieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearchWordsList = ref.watch(recentSearchWordsProvider);
    final isTurnOffRecentSearchWords =
        ref.watch(isTurnOffRecentSearchWordsProvider);

    return Container(
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
          isTurnOffRecentSearchWords == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(24.0),
                  color: white,
                  child: Center(
                    child: Text(
                      'Recent search words function has been turned off.',
                      style: recentSearchWordStyle.copyWith(
                        color: grey,
                      ),
                    ),
                  ),
                )
              : recentSearchWordsList.isEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(24.0),
                      color: white,
                      child: Center(
                        child: Text('No recent search words',
                            style: recentSearchWordStyle.copyWith(
                              color: grey,
                            )),
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
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
                              Expanded(
                                child: GestureDetector(
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
                                        .read(
                                            recentSearchWordsProvider.notifier)
                                        .saveRecentSearchWords(
                                          recentSearchWordsList[index]
                                              .recentSearchWord,
                                          DateTime.now(),
                                        );
                                  },
                                  child: Text(
                                    recentSearchWordsList[index]
                                        .recentSearchWord,
                                    style: recentSearchWordStyle,
                                  ),
                                ),
                              ),
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
                                            .recentSearchWord,
                                      );
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
                  onTap: () {
                    isTurnOffRecentSearchWords == true
                        ? ref
                            .read(isTurnOffRecentSearchWordsProvider.notifier)
                            .update(
                              (state) => false,
                            )
                        : showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => NoTitleAlertDialogWidget(
                              isOneButton: false,
                              contentText:
                                  'Do you want to stop using recent search words?',
                              okButtonOnPressed: () {
                                ref
                                    .read(isTurnOffRecentSearchWordsProvider
                                        .notifier)
                                    .update(
                                      (state) => true,
                                    );
                                Navigator.pop(context);
                              },
                              cancelButtonOnPressed: () =>
                                  Navigator.pop(context),
                            ),
                          );
                  },
                  child: Text(
                    isTurnOffRecentSearchWords
                        ? 'Turn on recent seach words'
                        : 'Turn off recent seach words',
                    style: recentSearchWordDateTimeStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                  width: 1.0,
                  height: 15,
                  color: backgroundColor,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => NoTitleAlertDialogWidget(
                        isOneButton: false,
                        contentText:
                            'Do you want to delete all recent search words history?',
                        okButtonOnPressed: () {
                          ref
                              .read(recentSearchWordsProvider.notifier)
                              .removeAllRecentSearchWords();
                          Navigator.pop(context);
                        },
                        cancelButtonOnPressed: () => Navigator.pop(context),
                      ),
                    );
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
    );
  }
}
