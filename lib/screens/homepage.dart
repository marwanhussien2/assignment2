import 'package:flutter/material.dart' hide SearchBar;
import '../models/news_item.dart';
import '../managers/bookmark_manager.dart';
import '../components/app_header.dart';
import '../components/search_bar.dart';
import '../components/bottom_navigation.dart';
import 'explore_page.dart';
import 'bookmarks_page.dart';
import 'profile_page.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<NewsItem> _allNewsItems = [];
  final List<NewsItem> _filteredNewsItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeNewsItems();
    _filteredNewsItems.addAll(_allNewsItems);

    _searchController.addListener(() {
      _filterNews(_searchController.text);
    });
  }

  void _initializeNewsItems() {
    _allNewsItems.addAll([
      NewsItem(
        id: '1',
        title: 'Russian warship: Moskva sinks in Black Sea',
        category: 'Europe',
        source: 'BBC News',
        timeAgo: '4h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1547981609-4b6bf67b7d52?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '2',
        title: "Ukraine's President Zelensky to address UN",
        description: 'BBC: Blood money being paid for Russian oil...',
        category: 'Europe',
        source: 'BBC News',
        timeAgo: '14m ago',
        imageUrl:
            'https://images.unsplash.com/photo-1618477388957-7a1eac0e11a8?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '3',
        title: "Her train broke down. Her phone died. And then she met her...",
        category: 'Travel',
        source: 'Travel News',
        timeAgo: '1h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '4',
        title:
            "New AI model breaks performance records in language understanding",
        category: 'Technology',
        source: 'Tech Daily',
        timeAgo: '2h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '5',
        title: "Underdog team makes historic comeback in championship finals",
        category: 'Sports',
        source: 'Sports Network',
        timeAgo: '3h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '6',
        title:
            "Breakthrough in cancer treatment shows promising results in trials",
        category: 'Health',
        source: 'Health Today',
        timeAgo: '5h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
      NewsItem(
        id: '7',
        title:
            "NASA discovers Earth-like planet in habitable zone of distant star",
        category: 'Science',
        source: 'Space News',
        timeAgo: '6h ago',
        imageUrl:
            'https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=300&fit=crop',
        isBookmarked: false,
      ),
    ]);
  }

  void _filterNews(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredNewsItems.clear();

      if (query.isEmpty) {
        _filteredNewsItems.addAll(_allNewsItems);
      } else {
        final lowerCaseQuery = query.toLowerCase();
        _filteredNewsItems.addAll(
          _allNewsItems.where(
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
      _filteredNewsItems.clear();
      _filteredNewsItems.addAll(_allNewsItems);
    });
  }

  void _toggleBookmark(String newsId) {
    setState(() {
      final newsIndex = _allNewsItems.indexWhere((news) => news.id == newsId);
      if (newsIndex != -1) {
        _allNewsItems[newsIndex].isBookmarked =
            !_allNewsItems[newsIndex].isBookmarked;

        final filteredIndex = _filteredNewsItems.indexWhere(
          (news) => news.id == newsId,
        );
        if (filteredIndex != -1) {
          _filteredNewsItems[filteredIndex].isBookmarked =
              _allNewsItems[newsIndex].isBookmarked;
        }

        BookmarkManager.instance.toggleBookmark(_allNewsItems[newsIndex]);
      }
    });
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        setState(() {
          _currentIndex = index;
        });
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

            // News Content
            Expanded(
              child: _isSearching && _filteredNewsItems.isEmpty
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
          'Search Results (${_filteredNewsItems.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      ..._filteredNewsItems.map((news) => _buildNewsCard(news)).toList(),
    ];
  }

  List<Widget> _buildAllSections() {
    return [
      _buildTrendingSection(),

      _buildLatestSection(),

      _buildNewsSection(
        'Europe',
        _allNewsItems.where((news) => news.category == 'Europe').toList(),
      ),
      _buildNewsSection(
        'Travel',
        _allNewsItems.where((news) => news.category == 'Travel').toList(),
      ),
      _buildNewsSection(
        'Technology',
        _allNewsItems.where((news) => news.category == 'Technology').toList(),
      ),
      _buildNewsSection(
        'Sports',
        _allNewsItems.where((news) => news.category == 'Sports').toList(),
      ),
      _buildNewsSection(
        'Health',
        _allNewsItems.where((news) => news.category == 'Health').toList(),
      ),
      _buildNewsSection(
        'Science',
        _allNewsItems.where((news) => news.category == 'Science').toList(),
      ),
    ];
  }

  Widget _buildTrendingSection() {
    final trendingNews = _allNewsItems.firstWhere(
      (news) => news.title.contains('Moskva'),
      orElse: () => _allNewsItems.first,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending',
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
                'Latest',
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
                _buildCategoryChip('Sports'),
                _buildCategoryChip('Politics'),
                _buildCategoryChip('Business'),
                _buildCategoryChip('Health'),
                _buildCategoryChip('Travel'),
                _buildCategoryChip('Science'),
                _buildCategoryChip('Technology'),
              ],
            ),
          ),
        ],
      ),
    );
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
