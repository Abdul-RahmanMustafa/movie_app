
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildOnboardingPage(AppAssets.onboarding1, 0),
          _buildOnboardingPage(AppAssets.onboarding2, 1),
          _buildOnboardingPage(AppAssets.onboarding3, 2),
          _buildOnboardingPage(AppAssets.onboarding4, 3),
          _buildOnboardingPage(AppAssets.onboarding5, 4),
          _buildOnboardingPage(AppAssets.onboarding6, 5),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(String imagePath, int pageIndex) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),

        if (pageIndex == 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildSecondPage(1),
          )
        else if (pageIndex >= 2 && pageIndex <= 5)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildSecondPage(pageIndex),
          )
        else
          Positioned(
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            bottom: screenHeight * 0.12,
            child: _buildDefaultPage(pageIndex),
          ),
      ],
    );
  }

  Widget _buildDefaultPage(int pageIndex) {
    return Column(
      children: [
        const Text(
          'Find Your Next Favorite Movie Here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Get access to a huge library of movies '
              'to suit all tastes. You will surely like it.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFFBDBDBD),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildButtons(pageIndex),
      ],
    );
  }



  Widget _buildSecondPage(int pageIndex) {
    final titles = {
      1: 'Discover Movies',
      2: 'Explore All Genres',
      3: 'Create Watchlists',
      4: 'Rate, Review, and Learn',
      5: 'Start Watching Now',
    };

    final descriptions = {
      1: 'Explore a vast collection of movies in all qualities and genres. '
          'Find your next favorite film with ease.',
      2: 'Discover movies from every genre, in all available qualities. '
          'Find something new and exciting to watch every day.',
      3: 'Save movies to your watchlist to keep track of what you want to watch next. '
          'Enjoy films in various qualities and genres.',
      4: 'Share your thoughts on the movies you\'ve watched. '
          'Dive deep into film details and help others discover great movies '
          'with your reviews.',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            titles[pageIndex]!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (pageIndex != 5) ...[
            const SizedBox(height: 12),
            Text(
              descriptions[pageIndex]!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
          const SizedBox(height: 20),
          _buildButtons(pageIndex),
        ],
      ),
    );
  }



  Widget _buildButtons(int pageIndex) {
    final buttonText = switch (pageIndex) {
      0 => 'Explore Now',
      5 => 'Finish',
      _ => 'Next',
    };

    if (pageIndex == 0 || pageIndex == 1) {
      return _buildPrimaryButton(buttonText);
    }

    if (pageIndex >= 2 && pageIndex <= 4) {
      return Column(
        children: [
          _buildPrimaryButton(buttonText),
          const SizedBox(height: 12),
          _buildOutlinedBackButton(),
        ],
      );
    }

    return Column(
      children: [
        _buildPrimaryButton(buttonText),
        const SizedBox(height: 12),
        _buildOutlinedBackButton(),
      ],
    );
  }

  Widget _buildPrimaryButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _goNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _goBack,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Back',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
