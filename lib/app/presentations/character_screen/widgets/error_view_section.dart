import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/text_widget.dart';
import '../provider/character_screen_provider.dart';

class ErrorViewSection extends StatelessWidget {
  final CharacterScreenProvider provider;

  const ErrorViewSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            TextWidget.titleMedium('No Internet Connection'),
            const SizedBox(height: 8),
            TextWidget.bodySmall(
              'Please check your connection and try again to see the latest characters.',
              textAlign: TextAlign.center,
              color: AppColors.grey,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: PrimaryButton(
                text: 'Try Again',
                onPressed: () => provider.refresh(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
