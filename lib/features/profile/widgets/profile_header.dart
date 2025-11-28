import 'package:chatus/generated/assets.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:chatus/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardColor.withOpacity(0.25),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.all(20),
          child: Lottie.asset(Assets.lottieProfile),
        ),

        const SizedBox(height: 16),

        Text(
          'Sarim Rabbi',
          style: TextStyle(
            color: AppColors.textColor1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'sarimrabbi@gmail.com',
          style: TextStyle(fontSize: 14, color: AppColors.textColor2),
        ),
      ],
    );
  }
}
