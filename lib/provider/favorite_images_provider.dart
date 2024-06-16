import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteImagesProvider =
    StateNotifierProvider<FavoriteImagesNotifier, List<String>>((ref) {
  return FavoriteImagesNotifier();
});

class FavoriteImagesNotifier extends StateNotifier<List<String>> {
  FavoriteImagesNotifier() : super([]) {
    loadFavoriteImages();
  }

  void loadFavoriteImages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImages = prefs.getStringList('favorite_images') ?? [];
    state = savedImages;
  }

  void saveFavoriteImage(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    if (!state.contains(imageUrl)) {
      final updatedImages = [...state, imageUrl];
      await prefs.setStringList('favorite_images', updatedImages);
      state = updatedImages;
    }
  }

  void removeFavoriteImage(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedImages = state.where((url) => url != imageUrl).toList();
    await prefs.setStringList('favorite_images', updatedImages);
    state = updatedImages;
  }
}
