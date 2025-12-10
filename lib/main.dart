import 'package:flutter/material.dart';
import 'package:mobile_project/screens/homepage.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/select_country.dart';
import 'screens/choose_topics.dart' hide ChooseTopicsScreen;
import 'screens/select_news_source.dart';
import 'screens/fill_profile_screen.dart';
import 'screens/homepage.dart';
import 'screens/explore_page.dart';
import 'screens/bookmarks_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/select-country': (context) => const SelectCountryScreen(),
        '/choose-topics': (context) => const ChooseTopicsScreen(),
        '/select-news-sources': (context) => const SelectNewsSourcesScreen(),
        '/fill-profile': (context) => const FillProfileScreen(),
        '/home': (context) => const HomePageScreen(),
        '/explore': (context) => const ExplorePage(),
        '/bookmarks': (context) => const BookmarksPage(),
        '/profile': (context) => const ProfileScreen(), // Add this route
      },
    );
  }
}
