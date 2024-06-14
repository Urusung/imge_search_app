import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searhImageProvider = FutureProvider(
  (ref) async {
    Dio dio = Dio();
    const query = '아이유';
    const sort = 'recency';
    const page = 1;
    const size = 80;
    var url =
        'https://dapi.kakao.com/v2/search/image?query=$query&sort=$sort&page=$page&size=$size';
    String restApiKey = dotenv.get("REST_API_KEY");

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': "KakaoAK $restApiKey",
        },
      ),
    );
    return response;
  },
);
