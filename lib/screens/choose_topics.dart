import 'package:flutter/material.dart';
import 'package:mobile_project/screens/select_news_source.dart';

class ChooseTopicsScreen extends StatefulWidget {
  const ChooseTopicsScreen({super.key});

  @override
  State<ChooseTopicsScreen> createState() => _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState extends State<ChooseTopicsScreen> {
  final List<String> topics = [
    'National',
    'International',
    'Sport',
    'News',
    'Health',
    'Fashion',
    'Technology',
    'Science',
    'Art',
    'Politics',
  ];

  final Set<String> _selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Your Topics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4B6FFF),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4B6FFF),
              Color(0xFF4B6FFF),
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.15, 0.15, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.category_rounded,
                      size: 40,
                      color: Color(0xFF4B6FFF),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Customize Your Feed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select at least 2 topics you\'re interested in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4B6FFF).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${_selectedTopics.length}/2 selected',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6FFF),
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: (_selectedTopics.length / 2) * 80,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4B6FFF),
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4B6FFF), Color(0xFF6B8AFF)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  itemCount: topics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    final isSelected = _selectedTopics.contains(topic);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4B6FFF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4B6FFF)
                              : Colors.grey.shade300,
                          width: isSelected ? 0 : 1.5,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: const Color(0xFF4B6FFF).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            )
                          else
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                        ],
                        gradient: isSelected
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF4B6FFF), Color(0xFF6B8AFF)],
                              )
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTopics.remove(topic);
                              } else {
                                _selectedTopics.add(topic);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTopicIcon(topic, isSelected),
                                    const SizedBox(height: 8),
                                    Text(
                                      topic,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF4B6FFF),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              if (isSelected)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Color(0xFF4B6FFF),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: _selectedTopics.length >= 2
                        ? const LinearGradient(
                            colors: [Color(0xFF4B6FFF), Color(0xFF6B8AFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade500,
                            ],
                          ),
                    boxShadow: _selectedTopics.length >= 2
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4B6FFF).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedTopics.length >= 2
                          ? () {
                              // Navigate to news sources selection
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectNewsSourcesScreen(),
                                ),
                              );
                            }
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _selectedTopics.length >= 2
                                    ? Colors.white
                                    : Colors.grey.shade200,
                              ),
                            ),
                            if (_selectedTopics.length >= 2) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicIcon(String topic, bool isSelected) {
    final iconColor = isSelected ? Colors.white : const Color(0xFF4B6FFF);

    switch (topic.toLowerCase()) {
      case 'national':
        return Icon(Icons.flag_rounded, color: iconColor, size: 24);
      case 'international':
        return Icon(Icons.public_rounded, color: iconColor, size: 24);
      case 'sport':
        return Icon(Icons.sports_soccer_rounded, color: iconColor, size: 24);
      case 'news':
        return Icon(Icons.article_rounded, color: iconColor, size: 24);
      case 'health':
        return Icon(
          Icons.health_and_safety_rounded,
          color: iconColor,
          size: 24,
        );
      case 'fashion':
        return Icon(Icons.style_rounded, color: iconColor, size: 24);
      case 'technology':
        return Icon(Icons.computer_rounded, color: iconColor, size: 24);
      case 'science':
        return Icon(Icons.science_rounded, color: iconColor, size: 24);
      case 'art':
        return Icon(Icons.palette_rounded, color: iconColor, size: 24);
      case 'politics':
        return Icon(Icons.gavel_rounded, color: iconColor, size: 24);
      default:
        return Icon(Icons.category_rounded, color: iconColor, size: 24);
    }
  }
}
