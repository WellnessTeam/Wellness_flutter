import 'package:flutter/material.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/home/views/widgets/nav_tab.dart';
import 'package:frontend/features/home/views/widgets/nutrition_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'record_screen.dart';
import 'package:flutter/services.dart';

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

  Color _getProgressColor(double intakeRatio) {
    if (intakeRatio < 0.5) {
      return const Color.fromARGB(255, 255, 179, 80); // 50% 이하일 때 초록색
    } else if (intakeRatio >= 0.5 && intakeRatio < 0.75) {
      return const Color.fromARGB(255, 97, 170, 87); // 50%에서 80% 사이일 때 노란색
    } else if (intakeRatio >= 0.75 && intakeRatio <= 1.0) {
      return const Color.fromARGB(255, 68, 143, 255); // 80%에서 100% 사이일 때 주황색
    } else {
      return const Color.fromARGB(255, 255, 61, 87); // 100% 초과 시 빨간색
    }
  }

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
    if (_isRequestingPermission) return;

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
    });

    String selectedTab = tabs[index];
    context.go('/home/$selectedTab');
  }

  // 동적으로 AppBar 설정
  bool _isLatestFirst = true; // 정렬 상태

  PreferredSizeWidget _buildAppBar() {
    if (_selectedIndex == 0) {
      // 홈 화면 AppBar
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "홈 화면",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: "myfonts",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, // 아이콘 색상 고정
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // 상태바 배경색 고정
          statusBarIconBrightness: Brightness.dark, // 상태바 아이콘 색상 고정
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // 고정된 배경색
          ),
        ),
      );
    } else {
      // 기록 화면 AppBar
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "기록 화면",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: "myfonts",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, // 아이콘 색상 고정
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // 상태바 배경색 고정
          statusBarIconBrightness: Brightness.dark, // 상태바 아이콘 색상 고정
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // 고정된 배경색
          ),
        ),
        actions: [
          // 정렬 버튼 추가
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ToggleButtons(
              isSelected: [_isLatestFirst, !_isLatestFirst], // 선택 상태
              onPressed: (index) {
                setState(() {
                  _isLatestFirst = index == 0;
                });
              },
              color: Colors.black, // 비활성화 상태의 텍스트 색상
              selectedColor:
                  const Color.fromARGB(255, 0, 0, 0), // 활성화 상태의 텍스트 색상
              fillColor:
                  const Color.fromARGB(255, 211, 235, 255), // 활성화된 버튼의 배경색
              borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게
              borderColor: Colors.black, // 버튼 테두리 색상
              selectedBorderColor:
                  const Color.fromARGB(255, 0, 0, 0), // 활성화된 버튼의 테두리 색상
              borderWidth: 1.2, // 버튼 테두리 두께
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5), // 버튼 간격 추가
                  child: Text('최신순',
                      style: TextStyle(
                          fontFamily: "pretendard-regular", fontSize: 16)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5), // 버튼 간격 추가
                  child: Text('과거순',
                      style: TextStyle(
                          fontFamily: "pretendard-regular", fontSize: 16)),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // String todayDate = DateFormat('yyyy년 M월 d일').format(DateTime.now());

    return Scaffold(
      appBar: _buildAppBar(), // AppBar를 동적으로 설정
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromARGB(32, 255, 231, 231), //background color
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreen(context),
            RecordScreen(isLatestFirst: _isLatestFirst),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(57, 39, 138, 26),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.bottom > 0
                  ? Sizes.size8
                  : Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "홈",
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
                    color: const Color.fromARGB(255, 39, 138, 26),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const FaIcon(
                    size: 30,
                    FontAwesomeIcons.camera,
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.h48,
              NavTab(
                text: "나의 오늘",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.utensils,
                onTap: () => _onTap(1),
                selectedIcon: FontAwesomeIcons.utensils,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    // 더미 데이터
    String nickname = "홍길동";
    int intakeCalories = 1800;
    int recommendedCalories = 2000;
    double intakeRatio = intakeCalories / recommendedCalories;
    int remainingCalories = recommendedCalories - intakeCalories;

    double carbIntake = 201;
    double proteinIntake = 80;
    double fatIntake = 50;

    double carbRecommended = 200;
    double proteinRecommended = 100;
    double fatRecommended = 70;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gaps.v24,
          Align(
            alignment: Alignment.center,
            child: Text(
              "$nickname 님",
              style: const TextStyle(
                fontFamily: "myfonts",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Gaps.v20,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$intakeCalories",
                      style: const TextStyle(
                        fontFamily: "appname",
                        fontSize: 30,
                        color: Color.fromARGB(221, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: " / ",
                      style: TextStyle(
                        fontFamily: "myfonts",
                        fontSize: 18,
                        color: Color.fromARGB(221, 0, 0, 0),
                      ),
                    ),
                    TextSpan(
                      text: "$recommendedCalories kcal",
                      style: const TextStyle(
                        fontFamily: "myfonts",
                        fontSize: 18,
                        color: Color.fromARGB(221, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Gaps.v44,
                  SizedBox(
                    // 총 칼로리 원형 그래프 박스
                    height: 200.0,
                    width: 200.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 80.0, // 기존 링의 반지름
                          lineWidth: 13.0,
                          animation: true,
                          animationDuration: 1500,
                          percent:
                              intakeRatio > 1 ? 1.0 : intakeRatio, // 100%까지만 표현
                          center: SizedBox(
                            // Text의 크기를 고정하여 위치 변동 방지
                            height: 40.0,
                            child: Center(
                              child: Text(
                                "${(intakeRatio * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontFamily: "myfonts",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor:
                              const Color.fromARGB(132, 143, 165, 206),
                          progressColor:
                              _getProgressColor(intakeRatio), // 색상 조정
                          backgroundWidth: 8,
                        ),
                        if (intakeRatio > 1) // 100%가 넘으면 새로운 링을 추가
                          CircularPercentIndicator(
                            radius: 100.0, // 외곽 링의 반지름 (기존 링보다 큼)
                            lineWidth: 10.0,
                            animation: true,
                            animationDuration: 1500,
                            percent:
                                (intakeRatio - 1).clamp(0, 1), // 100% 초과 부분
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.transparent, // 배경을 투명하게
                            progressColor: const Color.fromARGB(
                                255, 255, 61, 87), // 초과 부분의 색상 설정
                            backgroundWidth: 5,
                          ),
                      ],
                    ),
                  ),
                  Gaps.v32,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: "myfonts",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: remainingCalories > 0
                              ? "$remainingCalories kcal"
                              : "권장량을 모두 채웠어요!",
                          style: TextStyle(
                            fontFamily: "myfonts",
                            color: remainingCalories > 0
                                ? const Color.fromARGB(221, 0, 160, 13)
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (remainingCalories > 0)
                          const TextSpan(
                            text: " 더 먹을 수 있어요!",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Gaps.v32,
                  NutritionBar(
                    label: "탄수화물",
                    intake: carbIntake,
                    recommended: carbRecommended,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 156, 194, 255),
                        Color.fromARGB(255, 48, 97, 255)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  Gaps.v8,
                  NutritionBar(
                    label: "단백질",
                    intake: proteinIntake,
                    recommended: proteinRecommended,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(195, 255, 241, 181),
                        Color.fromARGB(255, 255, 195, 30)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  Gaps.v8,
                  NutritionBar(
                    label: "지방",
                    intake: fatIntake,
                    recommended: fatRecommended,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 160, 192),
                        Color.fromARGB(255, 255, 56, 156)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
