import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/image/splash_bg.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE6DCDB).withOpacity(0.15),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: CornerCurveClipper(),
              child: Container(
                width: 160,
                height: 200,
                color: const Color(0xFF9FC7EA).withOpacity(0.55),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: RotatedBox(
              quarterTurns: 2,
              child: ClipPath(
                clipper: CornerCurveClipper(),
                child: Container(
                  width: 140,
                  height: 220,
                  color: const Color(0xFF88B2D8).withOpacity(0.7),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Image.asset("assets/image/splash_log.png", width: 280),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// كلاس واحد موحد لقص الأقواس المنحنية في كل الشاشة
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
