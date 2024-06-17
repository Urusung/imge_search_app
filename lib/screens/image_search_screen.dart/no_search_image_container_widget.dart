import 'package:flutter/material.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';

class NoSearchImageContainerWidget extends StatelessWidget {
  const NoSearchImageContainerWidget({
    super.key,
    required this.imagesSearchTextFieldController,
  });

  final TextEditingController imagesSearchTextFieldController;

  @override
  Widget build(BuildContext context) {
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
              text: imagesSearchTextFieldController.text.length > 27
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
}
