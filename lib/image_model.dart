class ImageModel {
  final String collection; // 사진의 소속 컬렉션
  final DateTime datetime; // 사진 업로드 날짜 및 시간
  final String displaySitename; // 사진 출처 사이트 이름
  final String docUrl; // 사진 출처 문서 URL
  final int height; // 사진 높이
  final String imageUrl; // 사진 URL
  final String thumbnailUrl; // 썸네일 이미지 URL
  final int width; // 사진 너비

  ImageModel({
    required this.collection,
    required this.datetime,
    required this.displaySitename,
    required this.docUrl,
    required this.height,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.width,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      collection: json['collection'] ?? '',
      datetime: DateTime.parse(json['datetime'] ?? ''),
      displaySitename: json['display_sitename'] ?? '',
      docUrl: json['doc_url'] ?? '',
      height: json['height'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      width: json['width'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'ImageModel(collection: $collection, datetime: $datetime, displaySitename: $displaySitename, docUrl: $docUrl, height: $height, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, width: $width)';
  }
}
