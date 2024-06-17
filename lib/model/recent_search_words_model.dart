class RecentSearchWordsModel {
  final String recentSearchWord;
  final DateTime dateTime;

  RecentSearchWordsModel(
      {required this.recentSearchWord, required this.dateTime});

  Map<String, dynamic> toJson() {
    return {
      'recentSearchWord': recentSearchWord,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory RecentSearchWordsModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchWordsModel(
      recentSearchWord: json['recentSearchWord'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
