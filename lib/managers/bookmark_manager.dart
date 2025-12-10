import '../models/news_item.dart';

class BookmarkManager {
  static final BookmarkManager _instance = BookmarkManager._internal();
  final List<NewsItem> _bookmarkedNews = [];

  factory BookmarkManager() {
    return _instance;
  }

  BookmarkManager._internal();

  static BookmarkManager get instance => _instance;

  List<NewsItem> get bookmarkedNews => List.from(_bookmarkedNews);

  void toggleBookmark(NewsItem news) {
    if (news.isBookmarked) {
      if (!_bookmarkedNews.any((item) => item.id == news.id)) {
        _bookmarkedNews.add(news);
      }
    } else {
      _bookmarkedNews.removeWhere((item) => item.id == news.id);
    }
  }

  void removeBookmark(String newsId) {
    _bookmarkedNews.removeWhere((item) => item.id == newsId);
  }

  bool isBookmarked(String newsId) {
    return _bookmarkedNews.any((item) => item.id == newsId);
  }
}
