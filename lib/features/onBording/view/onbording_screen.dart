import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'widget/intro_widget.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () async {
            await context.setLocale(
              context.locale.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en'),
            );
          },
          icon: Icon(Icons.language, color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: IntroductionScreen(
          globalBackgroundColor: AppColors.background,
          pages: [
            IntroWidget(
              image: 'assets/introImage/Overlay.png',
              title: "onboarding.title1".tr(),
              description: "onboarding.desc1".tr(),
            ),

            IntroWidget(
              image: 'assets/introImage/Background+Shadow.png',
              title: "onboarding.title2".tr(),
              description: "onboarding.desc2".tr(),
            ),

            IntroWidget(
              image: 'assets/introImage/Main Illustration Placeholder.png',
              title: "onboarding.title3".tr(),
              description: "onboarding.desc3".tr(),
            ),
          ],
          onDone: () {
            NavigateHelper.pushAndRemoveUntil(context, LoginScreen());
          },
          showSkipButton: true,
          skip: CustomeText(
            text: "buttons.skip".tr(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textColor: AppColors.green,
          ),
          next: CustomeText(
            text: "buttons.next".tr(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textColor: AppColors.green,
          ),
          done: CustomeText(
            text: "buttons.finish".tr(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textColor: AppColors.green,
          ),
          dotsDecorator: DotsDecorator(
            activeColor: AppColors.green,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
