import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/textfont_styles.dart';

class BottomBarItems extends StatelessWidget {
  const BottomBarItems({
    super.key,
    required this.onTap,
    required this.icon,
    required this.index,
    required this.currentInd,
    required this.title,
  });

  final Function() onTap;
  final IconData icon;
  final int index;
  final int currentInd;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      hoverColor: AppColors.transparent,
      onTap: onTap,
      child: SizedBox(
        width: 70,
        height: 47,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: currentInd == index ? AppColors.activeNavBarIconColor : AppColors.inActiveNavBarIconColor,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: getRegularStyle(
                fontSize: 12,
                color: currentInd == index ? AppColors.activeNavBarIconColor : AppColors.inActiveNavBarIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
