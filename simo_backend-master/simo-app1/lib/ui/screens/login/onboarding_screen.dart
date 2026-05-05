import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simo_app/ui/screens/login/login_screen.dart';
import '../../utils/responsive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Únete a',
                style: GoogleFonts.outfit(
                  fontSize: res.sp(32),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFdb007f),
                ),
              ),
              Text(
                'SIMÖ',
                style: GoogleFonts.outfit(
                  fontSize: res.sp(72),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFdb007f),
                  height: 1.0,
                ),
              ),
              SizedBox(height: res.hp(2)),
              Text(
                'empieza a reciclar\ntecnología de\nforma responsable.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: res.sp(22),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFdb007f),
                ),
              ),
              SizedBox(height: res.hp(5)),
              Image.asset(
                'assets/images/robot.png',
                height: res.hp(25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
