import 'package:flutter/material.dart' hide SearchBar;
import 'package:mobile_project/screens/homepage.dart';
import 'package:mobile_project/screens/profile_page.dart';
import '../models/news_item.dart';
import '../managers/bookmark_manager.dart';
import '../components/app_header.dart';
import '../components/search_bar.dart';
import '../components/bottom_navigation.dart';
import 'homepage.dart';
import 'explore_page.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  int _currentIndex = 2;
  final TextEditingController _searchController = TextEditingController();
  final List<NewsItem> _filteredBookmarks = [];
  bool _isSearching = false;

  List<NewsItem> get bookmarkedNews => BookmarkManager.instance.bookmarkedNews;

  @override
  void initState() {
    super.initState();
    _filteredBookmarks.addAll(bookmarkedNews);

    _searchController.addListener(() {
      _filterBookmarks(_searchController.text);
    });
  }

  void _filterBookmarks(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredBookmarks.clear();

      if (query.isEmpty) {
        _filteredBookmarks.addAll(bookmarkedNews);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        _filteredBookmarks.addAll(
          bookmarkedNews.where(
            (news) =>
                news.title.toLowerCase().contains(lowerCaseQuery) ||
                (news.description?.toLowerCase().contains(lowerCaseQuery) ??
                    false) ||
                news.category.toLowerCase().contains(lowerCaseQuery) ||
                news.source.toLowerCase().contains(lowerCaseQuery),
          ),
        );
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _filteredBookmarks.clear();
      _filteredBookmarks.addAll(bookmarkedNews);
    });
  }

  void _toggleBookmark(String newsId) {
    setState(() {
      BookmarkManager.instance.removeBookmark(newsId);
      _filteredBookmarks.removeWhere((item) => item.id == newsId);
    });
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const HomePageScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const ExplorePage(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        // Already on bookmarks page
        setState(() {
          _currentIndex = index;
        });
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const ProfileScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and icons
            AppHeader(
              onNotificationTap: () => print('Notifications tapped'),
              onFilterTap: () => print('Filter tapped'),
            ),

            // Search Bar
            SearchBar(
              controller: _searchController,
              isSearching: _isSearching,
              onClear: _clearSearch,
              onChanged: (value) {
                setState(() {
                  _isSearching = value.isNotEmpty;
                });
              },
            ),

            // Bookmarks Content
            Expanded(
              child: bookmarkedNews.isEmpty
                  ? _buildEmptyState()
                  : _isSearching && _filteredBookmarks.isEmpty
                  ? _buildNoResults()
                  : _buildBookmarksContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildBookmarksContent() {
    final displayBookmarks = _isSearching ? _filteredBookmarks : bookmarkedNews;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _isSearching
                  ? 'Search Results (${_filteredBookmarks.length})'
                  : 'Your Bookmarks (${bookmarkedNews.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ...displayBookmarks
              .map(
                (news) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: _buildNewsCard(news),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNewsCard(NewsItem news) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B6FFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    news.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B6FFF),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (news.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    news.description!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      news.source,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      news.timeAgo,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(news.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _toggleBookmark(news.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Color(0xFF4B6FFF),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No bookmarks yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save articles to read later by tapping the\nbookmark icon on any news card',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No bookmarks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try different keywords',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
