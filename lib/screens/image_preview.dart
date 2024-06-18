import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:imge_search_app/colors.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: const IconThemeData(color: white),
        elevation: 0,
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
