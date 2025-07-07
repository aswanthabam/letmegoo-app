import 'package:flutter/material.dart';
import 'package:letmegoo/constants/app_images.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/screens/user_detail_reg_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _lockController;
  late AnimationController _textController;

  late Animation<Offset> _lockSlide;
  late Animation<double> _lockFade;
  late Animation<double> _lockScale;

  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // Single smooth controller for lock animation
    _lockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Smooth lock entry with gentle settle
    _lockSlide = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _lockController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Lock fade in
    _lockFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _lockController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Subtle scale for gentle landing effect
    _lockScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _lockController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Text animations
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _startSequence();
  }

  Future<void> _startSequence() async {
    try {
      // Step 1: Lock enters smoothly from top
      await _lockController.forward();

      // Step 2: Small pause to let lock settle
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 3: Text appears
      setState(() => _showText = true);
      await _textController.forward();

      // Step 4: Wait and navigate
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (_, __, ___) => const UserDetailRegPage(),
            transitionsBuilder:
                (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UserDetailRegPage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _lockController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top spacing
              SizedBox(height: screenHeight * 0.05),

              // Text Content - Appears after lock settles
              Container(
                constraints: BoxConstraints(
                  maxWidth:
                      isLargeScreen
                          ? 600
                          : isTablet
                          ? 500
                          : double.infinity,
                ),
                child:
                    _showText
                        ? SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textFade,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome to Let Me Go 👋',
                                  style: AppFonts.semiBold24().copyWith(
                                    fontSize:
                                        screenWidth *
                                        (isLargeScreen
                                            ? 0.028
                                            : isTablet
                                            ? 0.04
                                            : 0.065),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.02),

                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "You're just a ",
                                        style: AppFonts.regular16().copyWith(
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "few steps",
                                        style: AppFonts.semiBold16().copyWith(
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                      TextSpan(
                                        text: " away from getting started.",
                                        style: AppFonts.regular16().copyWith(
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.01),

                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "As a ",
                                        style: AppFonts.regular16().copyWith(
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "new user",
                                        style: AppFonts.semiBold16().copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ", we need a few ",
                                        style: AppFonts.regular16().copyWith(
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "basic details",
                                        style: AppFonts.regular16().copyWith(
                                          color: AppColors.primary,
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                      TextSpan(
                                        text: " to set things up.",
                                        style: AppFonts.regular16().copyWith(
                                          fontSize:
                                              screenWidth *
                                              (isLargeScreen
                                                  ? 0.018
                                                  : isTablet
                                                  ? 0.028
                                                  : 0.045),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : SizedBox(height: screenHeight * 0.15),
              ),

              SizedBox(height: screenHeight * 0.08),

              // Lock Image - Single smooth animation
              Center(
                child: AnimatedBuilder(
                  animation: _lockController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _lockSlide,
                      child: FadeTransition(
                        opacity: _lockFade,
                        child: ScaleTransition(
                          scale: _lockScale,
                          child: Image.asset(
                            AppImages.lock,
                            width:
                                screenWidth *
                                (isLargeScreen
                                    ? 0.2
                                    : isTablet
                                    ? 0.25
                                    : 0.45),
                            height:
                                screenWidth *
                                (isLargeScreen
                                    ? 0.2
                                    : isTablet
                                    ? 0.25
                                    : 0.45),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom spacing
              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
