import 'package:chatus/modules/base/widgets/bottom_bar_items.dart';
import 'package:chatus/modules/settings/screen.dart';
import 'package:chatus/modules/status/screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../home/screen.dart';
import 'controller.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BaseController(),
      child: Consumer<BaseController>(
        builder: (context, provider, child) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Consumer<BaseController>(
              builder: (context, provider, child) {
                switch (provider.index) {
                  case 0:
                    return const HomeScreen();
                  case 1:
                    return const StatusScreen();
                  case 2:
                    return const SettingsScreen();
                  default:
                    return Container();
                }
              },
            ),
            bottomNavigationBar: Consumer<BaseController>(
              builder: (context, provider, child) => _buildBottomNavBar(context, provider),
            ),
          );
        },
      ),
    );
  }

  BottomAppBar _buildBottomNavBar(BuildContext context, BaseController provider) {
    return BottomAppBar(
      elevation: 0,
      color: Colors.transparent,
      shape: const CircularNotchedRectangle(),
      notchMargin: 0,
      clipBehavior: Clip.none,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.navbarBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(.3), width: 1),
          boxShadow: [BoxShadow(color: AppColors.navBarShadowColor, blurRadius: 4, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(icon: Icons.chat, isSelected: provider.index == 0, onTap: () => provider.setIndex(0)),
            _buildNavButton(icon: Icons.camera_alt, isSelected: provider.index == 1, onTap: () => provider.setIndex(1)),

            _buildNavButton(icon: Icons.settings, isSelected: provider.index == 2, onTap: () => provider.setIndex(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black.withOpacity(0.8) : Colors.transparent,
        ),
        child: Icon(icon, color: isSelected ? Colors.red : Colors.white, size: 24),
      ),
    );
  }
}
