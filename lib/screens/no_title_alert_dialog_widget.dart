import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imge_search_app/colors.dart';

class NoTitleAlertDialogWidget extends ConsumerWidget {
  const NoTitleAlertDialogWidget({
    super.key,
    required this.contentText,
    required this.okButtonOnPressed,
    required this.cancelButtonOnPressed,
    required this.isOneButton,
  });

  final String contentText;
  final VoidCallback okButtonOnPressed;
  final VoidCallback cancelButtonOnPressed;
  final bool isOneButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(right: 12.0),
      content: Text(
        contentText,
      ),
      actions: isOneButton
          ? [
              TextButton(
                onPressed: okButtonOnPressed,
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: szsBlue,
                  ),
                ),
              ),
            ]
          : [
              TextButton(
                onPressed: cancelButtonOnPressed,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: szsBlue,
                  ),
                ),
              ),
              TextButton(
                onPressed: okButtonOnPressed,
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: szsBlue,
                  ),
                ),
              ),
            ],
    );
  }
}
