import 'package:flutter/material.dart' hide SearchBar;
import 'package:mobile_project/screens/homepage.dart';
import 'package:mobile_project/screens/profile_page.dart';
import '../models/news_item.dart';
import '../managers/bookmark_manager.dart';
import '../components/app_header.dart';
import '../components/search_bar.dart';
import '../components/bottom_navigation.dart';
import 'bookmarks_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  final List<NewsItem> _exploreNews = [];
  final List<NewsItem> _filteredNews = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeExploreNews();
    _filteredNews.addAll(_exploreNews);

    _searchController.addListener(() {
      _filterNews(_searchController.text);
    });
  }

  void _initializeExploreNews() {
    _exploreNews.addAll([
      NewsItem(
        id: '8',
        title: 'Global markets react to new economic policies',
        category: 'Business',
        source: 'Financial Times',
        timeAgo: '1h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '9',
        title: 'New species discovered in Amazon rainforest',
        category: 'Science',
        source: 'Nature Journal',
        timeAgo: '3h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1448375240586-882707db888b?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '10',
        title: 'Film festival announces groundbreaking winners',
        category: 'Entertainment',
        source: 'Hollywood Reporter',
        timeAgo: '5h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1489599809505-fb40ebc14d25?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '11',
        title: 'Revolutionary electric car breaks distance record',
        category: 'Technology',
        source: 'Auto News',
        timeAgo: '7h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '12',
        title: 'Ancient artifacts found in Mediterranean excavation',
        category: 'History',
        source: 'Archaeology Today',
        timeAgo: '1d ago',
        imageUrl:
            'https://images.unsplash.com/photo-1539650116574-75c0c6d73f5e?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '13',
        title: 'Climate summit reaches historic agreement',
        category: 'Environment',
        source: 'Green World',
        timeAgo: '2d ago',
        imageUrl:
            'https://images.unsplash.com/photo-1569163139394-de44cb2c8cb8?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
    ]);
  }

  void _filterNews(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredNews.clear();

      if (query.isEmpty) {
        _filteredNews.addAll(_exploreNews);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        _filteredNews.addAll(
          _exploreNews.where(
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
      _filteredNews.clear();
      _filteredNews.addAll(_exploreNews);
    });
  }

  void _toggleBookmark(String newsId) {
    setState(() {
      final newsIndex = _exploreNews.indexWhere((news) => news.id == newsId);
      if (newsIndex != -1) {
        _exploreNews[newsIndex].isBookmarked =
            !_exploreNews[newsIndex].isBookmarked;

        final filteredIndex = _filteredNews.indexWhere(
          (news) => news.id == newsId,
        );
        if (filteredIndex != -1) {
          _filteredNews[filteredIndex].isBookmarked =
              _exploreNews[newsIndex].isBookmarked;
        }

        BookmarkManager.instance.toggleBookmark(_exploreNews[newsIndex]);
      }
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
        setState(() {
          _currentIndex = index;
        });
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const BookmarksPage(),
            transitionDuration: Duration.zero,
          ),
        );
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

            Expanded(
              child: _isSearching && _filteredNews.isEmpty
                  ? _buildNoResults()
                  : _buildNewsContent(),
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

  Widget _buildNewsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _isSearching ? _buildSearchResults() : _buildAllSections(),
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Search Results (${_filteredNews.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      ..._filteredNews.map((news) => _buildNewsCard(news)).toList(),
    ];
  }

  List<Widget> _buildAllSections() {
    return [
      _buildTrendingSection(),

      _buildLatestSection(),

      ..._buildCategorySections(),
    ];
  }

  Widget _buildTrendingSection() {
    final trendingNews = _exploreNews.first;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending in Explore',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4B6FFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              trendingNews.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildNewsCard(trendingNews),
        ],
      ),
    );
  }

  Widget _buildLatestSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Discoveries',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All', isSelected: true),
                _buildCategoryChip('Business'),
                _buildCategoryChip('Entertainment'),
                _buildCategoryChip('History'),
                _buildCategoryChip('Environment'),
                _buildCategoryChip('Science'),
                _buildCategoryChip('Technology'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategorySections() {
    final categories = _exploreNews
        .map((news) => news.category)
        .toSet()
        .toList();

    return categories.map((category) {
      final categoryNews = _exploreNews
          .where((news) => news.category == category)
          .toList();
      return _buildNewsSection(category, categoryNews);
    }).toList();
  }

  Widget _buildNewsSection(String title, List<NewsItem> newsItems) {
    if (newsItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...newsItems
              .map(
                (news) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
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
                  child: Icon(
                    news.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: news.isBookmarked
                        ? const Color(0xFF4B6FFF)
                        : Colors.grey,
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

  Widget _buildCategoryChip(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4B6FFF) : const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
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
            'No results found',
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
