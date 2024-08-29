import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/features/authentication/views/height_screen.dart';
import 'package:frontend/features/authentication/views/login_screen.dart';
import 'package:frontend/features/authentication/views/birthday_screen.dart'; // BirthdayScreen import
import 'package:frontend/features/authentication/views/gender_screen.dart'; // ProfileDetailsScreen import
import 'package:frontend/features/authentication/views/weight_screen.dart';
import 'package:frontend/features/home/views/home_screen.dart'; // HomeScreen import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      routerConfig: _router,
      theme: ThemeData(
        primaryColor: const Color(0xff28B0EE),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // Korean
      ],
    );
  }
}

// GoRouter 설정
final GoRouter _router = GoRouter(
  //initialLocation: BirthdayScreen.routeURL,
  routes: [
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: BirthdayScreen.routeName,
      path: BirthdayScreen.routeURL,
      builder: (context, state) => const BirthdayScreen(),
    ),
    GoRoute(
      name: GenderScreen.routeName,
      path: GenderScreen.routeURL,
      builder: (context, state) => const GenderScreen(),
    ),
    GoRoute(
      name: HeightScreen.routeName,
      path: HeightScreen.routeURL,
      builder: (context, state) => const HeightScreen(),
    ),
    GoRoute(
      name: WeightScreen.routeName,
      path: WeightScreen.routeURL,
      builder: (context, state) => const WeightScreen(),
    ),
    GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeURL, // "/home/:tab"
      builder: (context, state) {
        final tab = state.pathParameters['tab'] ?? 'home'; // 탭 값 가져오기
        return HomeScreen(tab: tab);
      },
    ),
  ],
);
