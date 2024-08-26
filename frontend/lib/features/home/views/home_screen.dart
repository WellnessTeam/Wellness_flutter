import 'package:flutter/material.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/home/views/widgets/nav_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  final String tab;

  const HomeScreen({
    super.key,
    required this.tab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> tabs = [
    "home",
    "discover",
    "xxxx",
    "inbox",
    "profile",
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _getIndexFromTab(widget.tab);
  }

  int _getIndexFromTab(String tab) {
    switch (tab) {
      case "home":
        return 0;
      case "discover":
        return 1;
      case "inbox":
        return 3;
      case "profile":
        return 4;
      default:
        return 0;
    }
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: _buildPlaceholderScreen("Home"),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: _buildPlaceholderScreen("Upload"),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: _buildPlaceholderScreen("Analyze"),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: _buildPlaceholderScreen("Profile"),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + Sizes.size12),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
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
              NavTab(
                text: "Upload",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.cameraRetro,
                onTap: () => _onTap(1),
                selectedIcon: FontAwesomeIcons.cameraRetro,
              ),
              Gaps.h24,
              NavTab(
                text: "Analyze",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.chartBar,
                onTap: () => _onTap(3),
                selectedIcon: FontAwesomeIcons.chartBar,
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIcon: FontAwesomeIcons.solidUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
