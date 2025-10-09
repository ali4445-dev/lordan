// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../paywall/paywall_screen.dart';
// import '../../utils/components/gradient_backdrop.dart';
//
// class SplashScreen extends StatefulWidget {
//   static const String routeName = '/splash';
//
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _logoScale;
//   late final Animation<double> _logoOpacity;
//
//   int _currentBenefitIndex = 0;
//   final List<String> _benefits = const ['PRIVATE', 'SECURE', 'ALWAYS READY'];
//
//   bool _isFirstTime = true;
//   int _currentMotivationIndex = 0;
//   final List<String> _motivationalWords = const ['Thinker', 'Speaker', 'Communicator'];
//
//   bool _showMotivationalText = false;
//   bool _showBenefits = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 4000),
//       vsync: this,
//     );
//
//     _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
//       ),
//     );
//
//     _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
//       ),
//     );
//
//     _checkFirstTimeUser();
//     _startAnimationSequence();
//   }
//
//   Future<void> _checkFirstTimeUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     _isFirstTime = prefs.getBool('isFirstTime') ?? true;
//
//     if (_isFirstTime) {
//       await prefs.setBool('isFirstTime', false);
//     }
//
//     setState(() {});
//   }
//
//   void _startAnimationSequence() {
//     _controller.forward();
//
//     // Start benefits animation after logo
//     Future.delayed(const Duration(milliseconds: 1000), () {
//       _animateBenefits();
//     });
//   }
//
//   void _animateBenefits() {
//     if (!mounted) return;
//
//     setState(() {
//       _currentBenefitIndex = 0;
//       _showBenefits = true;
//     });
//
//     Future.delayed(const Duration(milliseconds: 1200), () {
//       if (!mounted) return;
//       setState(() => _currentBenefitIndex = 1);
//
//       Future.delayed(const Duration(milliseconds: 1200), () {
//         if (!mounted) return;
//         setState(() => _currentBenefitIndex = 2);
//
//         // If first time user, start motivational sequence
//         if (_isFirstTime) {
//           Future.delayed(const Duration(milliseconds: 1200), () {
//             if (!mounted) return;
//             setState(() {
//               _showBenefits = false;
//               _showMotivationalText = true;
//             });
//             _animateMotivationalSequence();
//           });
//         } else {
//           // Navigate to app after benefits for returning users
//           Future.delayed(const Duration(milliseconds: 1200), () {
//             if (!mounted) return;
//             _navigateToNextScreen();
//           });
//         }
//       });
//     });
//   }
//
//   void _animateMotivationalSequence() {
//     if (!mounted) return;
//
//     setState(() => _currentMotivationIndex = 0);
//
//     Future.delayed(const Duration(milliseconds: 1200), () {
//       if (!mounted) return;
//       setState(() => _currentMotivationIndex = 1);
//
//       Future.delayed(const Duration(milliseconds: 1200), () {
//         if (!mounted) return;
//         setState(() => _currentMotivationIndex = 2);
//
//         // Navigate to onboarding after sequence
//         Future.delayed(const Duration(milliseconds: 1500), () {
//           if (!mounted) return;
//           _navigateToNextScreen();
//         });
//       });
//     });
//   }
//
//   void _navigateToNextScreen() {
//     if (_isFirstTime) {
//       context.go(PaywallScreen.routeName);
//     } else {
//       // Navigate to main app screen for returning users
//       context.go(PaywallScreen.routeName);
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background gradient
//           GradientBackdrop(isDark: isDark),
//
//           // Content
//           SafeArea(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Animated Logo
//                 AnimatedBuilder(
//                   animation: _controller,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _logoScale.value,
//                       child: Opacity(
//                         opacity: _logoOpacity.value,
//                         child: Image.asset(
//                           'assets/brand_logos/logo_png.png',
//                           width: 120,
//                           color: Colors.white.withValues(alpha: 230),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Thank you text
//                 AnimatedOpacity(
//                   opacity: _controller.value,
//                   duration: const Duration(milliseconds: 500),
//                   child: Text(
//                     'Thank you for downloading Lordan.',
//                     style: theme.textTheme.titleLarge?.copyWith(
//                       color: Colors.white.withValues(alpha: 230),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//
//                 // Benefits or Motivational Text
//                 if (_showBenefits)
//                   AnimatedOpacity(
//                     opacity: _showBenefits ? 1 : 0,
//                     duration: const Duration(milliseconds: 300),
//                     child: Text(
//                       _benefits[_currentBenefitIndex],
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         color: Colors.white.withValues(alpha: 230),
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),
//
//                 if (_showMotivationalText) ...[
//                   Text(
//                     'You have entered the path to become a better...',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: Colors.white.withValues(alpha: 179),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   AnimatedOpacity(
//                     opacity: _showMotivationalText ? 1 : 0,
//                     duration: const Duration(milliseconds: 300),
//                     child: Text(
//                       _motivationalWords[_currentMotivationIndex],
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/user_provider.dart';
import '../paywall/paywall_screen.dart';
import '../../utils/components/gradient_backdrop.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  int _currentBenefitIndex = 0;
  final List<String> _benefits = const ['PRIVATE', 'SECURE', 'ALWAYS READY'];

  bool _isFirstTime = true;
  int _currentMotivationIndex = 0;

  bool _showMotivationalText = false;
  bool _showBenefits = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _checkFirstTimeUser();
    _startAnimationSequence();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (_isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    setState(() {});
  }

  void _startAnimationSequence() {
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      _animateBenefits();
    });
  }

  void _animateBenefits() {
    if (!mounted) return;

    setState(() {
      _currentBenefitIndex = 0;
      _showBenefits = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _currentBenefitIndex = 1);

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() => _currentBenefitIndex = 2);

        if (_isFirstTime) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!mounted) return;
            setState(() {
              _showBenefits = false;
              _showMotivationalText = true;
            });
            _animateMotivationalSequence();
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!mounted) return;
            _navigateToNextScreen();
          });
        }
      });
    });
  }

  void _animateMotivationalSequence() {
    if (!mounted) return;

    setState(() => _currentMotivationIndex = 0);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _currentMotivationIndex = 1);

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() => _currentMotivationIndex = 2);

        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!mounted) return;
          _navigateToNextScreen();
        });
      });
    });
  }

  void _navigateToNextScreen() {
    context.go(PaywallScreen.routeName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackdrop(isDark: isDark),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 60),
              backgroundBlendMode: BlendMode.overlay,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 180),
                          padding: const EdgeInsets.only(right: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Image.asset(
                            'assets/brand_logos/logo_text.png',
                            width: 250,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 0),

                // Welcome text
                // AnimatedOpacity(
                //   opacity: _controller.value,
                //   duration: const Duration(milliseconds: 500),
                //   child: Text(
                //     'WELCOME TO LORDAN',
                //     style: theme.textTheme.headlineLarge?.copyWith(
                //       fontSize: 26,
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //       letterSpacing: 1.2,
                //     ),
                //   ),
                // ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: Text(
                          'WELCOME TO LORDAN',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child:  Text(
                          'Your Private AI Conversation Partner',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 48),

                // Benefits / Motivational text
                // if (_showBenefits)
                  AnimatedOpacity(
                    opacity: _showBenefits ? 1 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      _benefits[_currentBenefitIndex],
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "LORDAN LABS",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.normal,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
