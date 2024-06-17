import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:imge_search_app/colors.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: white),
        elevation: 0,
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          errorWidget: (context, url, error) {
            return Container(
              color: grey.withOpacity(0.1),
              height: 200.0,
              child: const Center(
                child: Icon(
                  Icons.error_rounded,
                  color: grey,
                ),
              ),
            );
          },
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
