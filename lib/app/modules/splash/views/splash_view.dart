import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/splash_provider.dart';

class SplashView extends StatelessWidget {
  static const route = '/splashScreen';
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return const Scaffold(
          backgroundColor: AppColors.primary,
          body: _SplashMobile(),
        );
      },
    );
  }
}

class _SplashMobile extends StatefulWidget {
  const _SplashMobile();

  @override
  State<_SplashMobile> createState() => _SplashMobileState();
}

class _SplashMobileState extends State<_SplashMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _scaleAnim = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              AppColors.primary,
              AppColors.darkScaffoldBackground,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModernLogo(),
              const SizedBox(height: 48),
              _buildAppDetails(),
              const SizedBox(height: 64),
              const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernLogo() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          size: 64,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAppDetails() {
    return Column(
      children: [
        Text(
          AppStrings.appName.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 4.0,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            AppStrings.appTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 0.5,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
