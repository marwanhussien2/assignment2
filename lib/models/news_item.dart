class NewsItem {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String source;
  final String timeAgo;
  final String imageUrl;
  bool isBookmarked;

  NewsItem({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.source,
    required this.timeAgo,
    required this.imageUrl,
    required this.isBookmarked,
  });

  NewsItem copyWith({bool? isBookmarked}) {
    return NewsItem(
      id: id,
      title: title,
      description: description,
      category: category,
      source: source,
      timeAgo: timeAgo,
      imageUrl: imageUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
