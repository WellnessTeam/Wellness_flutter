import 'package:flutter/material.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/home/views/widgets/nav_tab.dart';
import 'package:frontend/features/home/views/widgets/nutrition_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // 패키지 추가
import 'package:intl/intl.dart'; // 날짜 형식을 위한 패키지
import 'record_screen.dart'; // RecordScreen 추가

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  static const String routeURL = "/home/:tab";

  final String tab;

  const HomeScreen({
    super.key,
    required this.tab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double intakeRatio = 0.0;
  final List<String> tabs = [
    "home",
    "record",
  ];

  late int _selectedIndex;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _getIndexFromTab(widget.tab);
  }

  int _getIndexFromTab(String tab) {
    switch (tab) {
      case "home":
        return 0;
      case "record":
        return 1;
      default:
        return 0;
    }
  }

  Future<void> _pickImage() async {
    if (_isRequestingPermission) return; // 권한 요청 중복 방지

    _isRequestingPermission = true;

    try {
      var status = await Permission.storage.status;
      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image != null && mounted) {
          context.go('/analyze', extra: image);
        }
      } else {
        status = await Permission.photos.request();
        if (status.isGranted) {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.gallery);

          if (image != null && mounted) {
            context.go('/analyze', extra: image);
          }
        } else if (status.isDenied || status.isPermanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('갤러리 접근 권한이 필요합니다.'),
              action: SnackBarAction(
                label: '설정으로 이동',
                onPressed: () {
                  openAppSettings();
                },
              ),
            ),
          );
        }
      }
    } finally {
      _isRequestingPermission = false;
    }
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
      intakeRatio = 0.90;
    });

    String selectedTab = tabs[index];
    context.go('/home/$selectedTab');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreen(context),
          const RecordScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + Sizes.size12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavTab(
              text: "Home",
              isSelected: _selectedIndex == 0,
              icon: FontAwesomeIcons.houseUser,
              onTap: () => _onTap(0),
              selectedIcon: FontAwesomeIcons.houseUser,
            ),
            Gaps.h48,
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.camera,
                  color: Colors.white,
                ),
              ),
            ),
            Gaps.h48,
            NavTab(
              text: "Record",
              isSelected: _selectedIndex == 1,
              icon: FontAwesomeIcons.utensils,
              onTap: () => _onTap(1),
              selectedIcon: FontAwesomeIcons.utensils,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    // 현재 날짜를 불러오기 (시스템 날짜)
    String todayDate = DateFormat('yyyy년 M월 d일').format(DateTime.now());
    // 예시 데이터: 닉네임, 섭취 칼로리, 권장 칼로리
    String nickname = "홍길동";
    int intakeCalories = 1800; // 섭취 칼로리 예시
    int recommendedCalories = 2000; // 권장 칼로리 예시
    double intakeRatio = intakeCalories / recommendedCalories;

    // 예시 데이터: 탄수화물, 단백질, 지방
    double carbIntake = 150;
    double carbRecommended = 200;
    double proteinIntake = 80;
    double proteinRecommended = 100;
    double fatIntake = 50;
    double fatRecommended = 70;

    return Padding(
      padding: const EdgeInsets.all(Sizes.size12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 닉네임 표시
          Padding(
            padding: const EdgeInsets.only(top: Sizes.size48),
            child: Text(
              "$nickname 님",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // 깔끔한 컬러
              ),
            ),
          ),
          Gaps.v8,
          // 날짜 표시
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size24, vertical: Sizes.size6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                todayDate,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Gaps.v32,
          // 섭취 칼로리 / 권장 칼로리 원형 차트
          CircularPercentIndicator(
            radius: 110.0,
            lineWidth: 13.0,
            animation: true,
            animationDuration: 1000,
            percent: intakeRatio,
            center: Text(
              "${(intakeRatio * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black87, // 깔끔한 텍스트 컬러
              ),
            ),
            footer: Column(
              children: [
                Gaps.v16,
                Text(
                  "섭취 칼로리: $intakeCalories kcal",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gaps.v8,
                Text(
                  "권장 칼로리: $recommendedCalories kcal",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.blueAccent,
            backgroundColor: Colors.grey[200]!,
            backgroundWidth: 3,
          ),
          Gaps.v32,
          // 섭취/권장 탄단지 막대 그래프
          NutritionBar(
            label: "탄수화물",
            intake: carbIntake,
            recommended: carbRecommended,
            color: Colors.orange,
          ),
          Gaps.v8,
          NutritionBar(
            label: "단백질",
            intake: proteinIntake,
            recommended: proteinRecommended,
            color: Colors.green,
          ),
          Gaps.v8,
          NutritionBar(
            label: "지방",
            intake: fatIntake,
            recommended: fatRecommended,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
