import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_project/screens/select_news_source.dart';

class Country {
  final String name;
  final String flagUrl;

  Country({required this.name, required this.flagUrl});
}

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  List<Country> _countries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = true;
  bool _hasError = false;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    try {
      final uri = Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,flags',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Country> loaded = data.map((jsonItem) {
          final name = (jsonItem['name']['common'] as String);
          final flagUrl = (jsonItem['flags']['png'] as String);
          return Country(name: name, flagUrl: flagUrl);
        }).toList();
        loaded.sort((a, b) => a.name.compareTo(b.name));
        setState(() {
          _countries = loaded;
          _filteredCountries = loaded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _filterCountries(String query) {
    final lower = query.toLowerCase();
    final filtered = _countries
        .where((c) => c.name.toLowerCase().contains(lower))
        .toList();
    setState(() {
      _filteredCountries = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Your Country'),
          backgroundColor: const Color(0xFF4B6FFF),
        ),
        body: const Center(
          child: Text('Failed to load countries. Please try again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Country'),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: 'Search country',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  final isSelected = _selectedCountry == country;
                  return ListTile(
                    leading: Image.network(
                      country.flagUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                    title: Text(country.name),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFF4B6FFF))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCountry = country;
                      });
                    },
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedCountry != null
                      ? const Color(0xFF4B6FFF)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _selectedCountry != null
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChooseTopicsScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        title: const Text('Choose Your Topics'),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: topics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  final isSelected = _selectedTopics.contains(topic);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTopics.remove(topic);
                        } else {
                          _selectedTopics.add(topic);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4B6FFF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF4B6FFF)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        topic,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF4B6FFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTopics.isNotEmpty
                      ? const Color(0xFF4B6FFF)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _selectedTopics.isNotEmpty
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SelectNewsSourcesScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
