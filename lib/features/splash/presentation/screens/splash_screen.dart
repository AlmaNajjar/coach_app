import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/local_storage.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:coach_app/features/home/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// How long the splash stays on screen before leaving.
  static const _holdDuration = Duration(milliseconds: 1200);

  /// Exit animation of the splash elements (logo + corner shapes).
  static const _exitDuration = Duration(milliseconds: 700);

  /// Cross-fade to the next screen. It runs together with the exit animation,
  /// so the splash dissolves into the next screen instead of being cut.
  static const _routeDuration = Duration(milliseconds: 800);

  late final AnimationController _exitController;
  late final Animation<double> _exit;

  @override
  void initState() {
    super.initState();
    _exitController = AnimationController(vsync: this, duration: _exitDuration);
    _exit = _exitController.drive(CurveTween(curve: Curves.easeInOutCubic));
    _openInitialScreen();
  }

  @override
  void dispose() {
    _exitController.dispose();
    super.dispose();
  }

  Future<void> _openInitialScreen() async {
    await Future<void>.delayed(_holdDuration);
    final token = await LocalStorage.getData('token');
    if (!mounted) return;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final Widget destination = token == null || token.isEmpty
        ? const LogInScreen()
        : const HomeScreen();

    // The splash elements leave while the next screen fades in.
    if (!reduceMotion) _exitController.forward();
    Navigator.of(context).pushReplacement(
      _smoothRoute(destination, reduceMotion: reduceMotion),
    );
  }

  /// Fade-through with a very slight scale-up. The splash stays underneath
  /// while the route animates, so there is never a blank frame in between.
  Route<void> _smoothRoute(Widget destination, {required bool reduceMotion}) {
    return PageRouteBuilder<void>(
      transitionDuration: reduceMotion ? Duration.zero : _routeDuration,
      pageBuilder: (_, __, ___) => destination,
      transitionsBuilder: (_, animation, __, child) {
        final fade = animation.drive(
          CurveTween(
            curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
          ),
        );
        final scale = animation.drive(
          Tween<double>(begin: 0.97, end: 1).chain(
            CurveTween(curve: Curves.easeOutCubic),
          ),
        );
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final fadeOut = Tween<double>(begin: 1, end: 0).animate(_exit);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            "assets/image/splash.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE6DCDB).withValues(alpha: 0.15),
          ),

          // Top-left corner: slides out diagonally while fading.
          Positioned(
            top: 0,
            left: 0,
            child: FadeTransition(
              opacity: fadeOut,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-0.4, -0.4),
                ).animate(_exit),
                child: ClipPath(
                  clipper: CornerCurveClipper(),
                  child: Container(
                    width: 160,
                    height: 200,
                    color: const Color(0xFF9FC7EA).withValues(alpha: 0.55),
                  ),
                ),
              ),
            ),
          ),

          // Bottom-right corner: slides out in the opposite direction.
          Positioned(
            bottom: 0,
            right: 0,
            child: FadeTransition(
              opacity: fadeOut,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.4, 0.4),
                ).animate(_exit),
                child: RotatedBox(
                  quarterTurns: 2,
                  child: ClipPath(
                    clipper: CornerCurveClipper(),
                    child: Container(
                      width: 140,
                      height: 220,
                      color: const Color(0xFF88B2D8).withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Logo: gently grows and fades out.
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  FadeTransition(
                    opacity: fadeOut,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 1.08).animate(_exit),
                      child: Image.asset(
                        "assets/image/splash_log.png",
                        width: 280,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for curved corner arcs
class CornerCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.35,
      0,
      size.height,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}