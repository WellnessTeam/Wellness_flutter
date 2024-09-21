import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/features/authentication/views/height_screen.dart';
import 'package:frontend/features/home/views/login_screen.dart';
import 'package:frontend/features/authentication/views/birthday_screen.dart';
import 'package:frontend/features/authentication/views/gender_screen.dart';
import 'package:frontend/features/authentication/views/weight_screen.dart';
import 'package:frontend/features/home/views/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/home/views/analyze_page.dart';
import 'package:frontend/features/home/views/record_screen.dart';
import 'package:image_picker/image_picker.dart'; // AnalyzePage import
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // SystemChrome import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// SharedPreferences에서 토큰을 확인하는 함수
Future<String?> _checkToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  return token;
}

Future<void> _removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token'); // 저장된 'access_token' 삭제
  await prefs.remove('refresh_token');
  print("Token removed");
}

Future<void> main() async {
  final Logger logger = Logger(); // Logger 인스턴스 생성

  logger.i('App is starting'); // 앱 시작 로그
  WidgetsFlutterBinding.ensureInitialized(); // 플러그인 초기화

  //await _removeToken(); // 한번만 실행하고 이 부분 주석처리

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 투명한 상태바 설정
    statusBarIconBrightness: Brightness.dark, // 상태바 아이콘을 어두운 색으로 설정
  ));

  await dotenv.load(fileName: '.env');
  String? kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];

  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
  logger.i('Kakao SDK initialized'); // Kakao SDK 초기화 로그

  HttpOverrides.global = MyHttpOverrides();

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
      title: 'WELLNESS',
      theme: ThemeData(
        primaryColor: const Color(0xff28B0EE),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      locale: const Locale('ko'), // 기본 로케일 설정
      routerConfig: _router,
    );
  }
}

final Logger logger = Logger();
// GoRouter 설정
final GoRouter _router = GoRouter(
  initialLocation: LoginScreen.routeURL, // 항상 로그인 화면으로 초기 경로 설정
  routes: [
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
      // redirect: (context, state) async {
      //   // SharedPreferences에서 토큰 확인
      //   String? token = await _checkToken();

      //   // 토큰 확인 로그 추가
      //   if (token != null) {
      //     logger.i('Token found: $token');
      //     return HomeScreen.routeURL; // 토큰이 있으면 홈 화면으로 리다이렉트
      //   } else {
      //     logger.i('No token found, staying on LoginScreen');
      //     return null; // 토큰이 없으면 로그인 화면 유지
      //   }
      // },
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
      path: HomeScreen.routeURL,
      builder: (context, state) {
        final tab = state.pathParameters['tab'] ?? 'home'; // 탭 값 가져오기
        return HomeScreen(
          tab: tab,
        );
      },
    ),
    GoRoute(
      path: '/analyze',
      builder: (context, state) {
        final image = state.extra as XFile;
        return AnalyzePage(image: image);
      },
    ),
    GoRoute(
      path: '/home/record',
      builder: (context, state) {
        return const RecordScreen(
          isLatestFirst: true,
        );
      },
    ),
  ],
);
