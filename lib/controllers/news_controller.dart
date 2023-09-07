import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/api/news_repo.dart';
import 'package:quant/commons/snackbar.dart';
import 'package:quant/screens/home/news_model.dart';

final newsListProvider =
    FutureProvider.autoDispose.family<List<NewsArticle>, int>(
  (ref, page) async {
    final newsRepo = ref.watch(newsRepoProvider);
    return newsRepo.getAllNews(page: page);
  },
);

final searchNewsListProvider =
    FutureProvider.autoDispose.family<List<NewsArticle>, String>(
  (ref, search) async {
    final newsRepo = ref.watch(newsRepoProvider);
    return newsRepo.getSearchNews(query: search);
  },
);

final newsControllerProvider =
    StateNotifierProvider<NewsController, List<NewsArticle>>((ref) {
  return NewsController(newsRepo: ref.watch(newsRepoProvider));
});

class NewsController extends StateNotifier<List<NewsArticle>> {
  final NewsRepo _newsRepo;
  int _currentPage = 1;
  NewsController({required NewsRepo newsRepo})
      : _newsRepo = newsRepo,
        super([]);

  Future<void> getData() async {
    try {
      final List<NewsArticle> newss =
          await _newsRepo.getAllNews(page: _currentPage);
      state = [...state, ...newss];
      _currentPage++;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSearchData({required String query}) async {
    try {
      final List<NewsArticle> newss =
          await _newsRepo.getSearchNews(query: query);
      state = newss;
    } catch (e) {
      print(e);
    }
  }
}
