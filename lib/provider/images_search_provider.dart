import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imge_search_app/model/image_model.dart';

final imagesSearchProvider =
    StateNotifierProvider<ImagesSearchNotifier, AsyncValue<List<ImageModel>>>(
        (ref) {
  return ImagesSearchNotifier();
});

class ImagesSearchNotifier extends StateNotifier<AsyncValue<List<ImageModel>>> {
  ImagesSearchNotifier() : super(const AsyncValue.loading());
  int _page = 1;
  final int _size = 80;
  bool _isFetching = false;
  String _query = '';
  String _sort = 'accuracy';

  Future<void> searchImage(String query, String sort) async {
    if (query.trim() == '') {
      state = const AsyncValue.data([]);
      return;
    }
    _query = query;
    _page = 1;
    _isFetching = true;
    await fetchImages(sort);
  }

  Future<void> fetchMoreImages(String sort) async {
    if (_isFetching) return;
    _isFetching = true;
    _page++;
    await fetchImages(sort);
  }

  Future<void> fetchImages(String sort) async {
    try {
      Dio dio = Dio();
      _sort = sort;
      var url =
          'https://dapi.kakao.com/v2/search/image?query=$_query&sort=$_sort&page=$_page&size=$_size';
      String restApiKey = dotenv.get("REST_API_KEY");

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': "KakaoAK $restApiKey",
          },
        ),
      );

      List<ImageModel> imageModels = [];
      for (var document in response.data['documents']) {
        ImageModel imageModel = ImageModel.fromJson(document);
        imageModels.add(imageModel);
      }

      if (_page == 1) {
        state = AsyncValue.data(imageModels);
      } else {
        final currentImages = state.value ?? [];
        state = AsyncValue.data([...currentImages, ...imageModels]);
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    } finally {
      _isFetching = false;
    }
  }
}

final sortTypeProvider = StateProvider<String>((ref) => 'accuracy');
