import 'package:flutter/material.dart';
import 'package:mobile_project/screens/fill_profile_screen.dart';

class NewsSource {
  final String id;
  final String name;
  final String logoUrl;
  bool isFollowed;

  NewsSource({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.isFollowed = false,
  });
}

class SelectNewsSourcesScreen extends StatefulWidget {
  const SelectNewsSourcesScreen({super.key});

  @override
  State<SelectNewsSourcesScreen> createState() =>
      _SelectNewsSourcesScreenState();
}

class _SelectNewsSourcesScreenState extends State<SelectNewsSourcesScreen> {
  final List<NewsSource> sources = [
    NewsSource(
      id: 'bbc-news',
      name: 'BBC News',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/BBC_News_2019.svg/1200px-BBC_News_2019.svg.png',
    ),
    NewsSource(
      id: 'cnn',
      name: 'CNN',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/CNN.svg/800px-CNN.svg.png',
    ),
    NewsSource(
      id: 'fox-news',
      name: 'Fox News',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Fox_News_Channel_logo.svg/800px-Fox_News_Channel_logo.svg.png',
    ),
    NewsSource(
      id: 'the-verge',
      name: 'The Verge',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/The_Verge_2018_logo.svg/800px-The_Verge_2018_logo.svg.png',
    ),
    NewsSource(
      id: 'al-jazeera-english',
      name: 'Al Jazeera',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Al_Jazeera_English_Doha_Newsroom_-2.jpg/800px-Al_Jazeera_English_Doha_Newsroom_-2.jpg',
    ),
    NewsSource(
      id: 'reuters',
      name: 'Reuters',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Reuters_Logo_2014.svg/800px-Reuters_Logo_2014.svg.png',
    ),
    NewsSource(
      id: 'techcrunch',
      name: 'TechCrunch',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/TechCrunch_logo.svg/800px-TechCrunch_logo.svg.png',
    ),
  ];

  void toggleFollow(NewsSource source) {
    setState(() {
      source.isFollowed = !source.isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final followedCount = sources.where((s) => s.isFollowed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select News Sources'),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Instruction text
            const Text(
              'Follow at least 2 news sources',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                itemCount: sources.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final source = sources[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF4B6FFF)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildNewsSourceImage(
                            source.logoUrl,
                            source.name,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          source.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => toggleFollow(source),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: source.isFollowed
                                  ? const Color(0xFF4B6FFF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF4B6FFF),
                              ),
                            ),
                            child: Text(
                              source.isFollowed ? 'Following' : 'Follow',
                              style: TextStyle(
                                color: source.isFollowed
                                    ? Colors.white
                                    : const Color(0xFF4B6FFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            if (followedCount > 0)
              Text(
                'Following: $followedCount source${followedCount == 1 ? '' : 's'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: followedCount >= 2
                      ? const Color(0xFF4B6FFF)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: followedCount >= 2
                    ? () {
                        final followed = sources
                            .where((s) => s.isFollowed)
                            .map((s) => s.id)
                            .toList();
                        print('Followed sources: $followed');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FillProfileScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSourceImage(String imageUrl, String sourceName) {
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF4B6FFF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              sourceName.substring(0, 1),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B6FFF),
              ),
            ),
          ),
        );
      },
    );
  }
}
