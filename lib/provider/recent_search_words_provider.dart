import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imge_search_app/model/recent_search_words_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final recentSearchWordsProvider = StateNotifierProvider<
    RecentSearchWordsNotifier, List<RecentSearchWordsModel>>((ref) {
  return RecentSearchWordsNotifier();
});

class RecentSearchWordsNotifier
    extends StateNotifier<List<RecentSearchWordsModel>> {
  RecentSearchWordsNotifier() : super([]) {
    loadRecentSearchWords();
  }

  Future<void> loadRecentSearchWords() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWordsJson = prefs.getStringList('recent_search_words') ?? [];
    final savedWords = savedWordsJson
        .map(
          (wordJson) => RecentSearchWordsModel.fromJson(
            jsonDecode(
              wordJson,
            ),
          ),
        )
        .toList();
    state = savedWords;
  }

  Future<void> saveRecentSearchWords(
      String searchWord, DateTime currentDateTime) async {
    final prefs = await SharedPreferences.getInstance();
    final existingWordIndex = state.indexWhere((word) =>
        word.recentSearchWord ==
        searchWord); //로컬 저장소에 저장된 검색어 중 일치하는 검색어가 있는지 확인

    if (existingWordIndex == -1) {
      //일치하는 검색어가 없을 때
      final newSearchWord = RecentSearchWordsModel(
          recentSearchWord: searchWord, dateTime: currentDateTime);
      state = [...state, newSearchWord];
    } else {
      //일치하는 검색어가 있을 때
      state[existingWordIndex] = RecentSearchWordsModel(
          recentSearchWord: searchWord, dateTime: currentDateTime);
    }

    state.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (state.length > 10) {
      //state.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      state.removeAt(0);
    }
    final updatedWordsJson = state
        .map((word) => jsonEncode(word.toJson()))
        .toList(); // 검색어를 json 형태로 변환
    await prefs.setStringList(
        'recent_search_words', updatedWordsJson); // 로컬 저장소에 저장
  }

  Future<void> removeRecentSearchWord(String searchWord) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedWords =
        state.where((word) => word.recentSearchWord != searchWord).toList();
    final updatedWordsJson =
        updatedWords.map((word) => jsonEncode(word.toJson())).toList();
    await prefs.setStringList('recent_search_words', updatedWordsJson);
    state = updatedWords;
  }

  Future<void> removeAllRecentSearchWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_search_words');
    state = [];
  }
}

final isTurnOffRecentSearchWordsProvider = StateProvider<bool>((ref) => false);
