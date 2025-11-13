import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'onboarding/create_account_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Переход на следующий экран через 2 секунды
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateAccountScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Задняя сумка (светло-синяя)
              Positioned(
                left: 20,
                top: 25,
                child: CustomPaint(
                  size: const Size(60, 60),
                  painter: ShoppingBagPainter(
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              // Передняя сумка (темно-синяя)
              Positioned(
                left: 30,
                top: 25,
                child: CustomPaint(
                  size: const Size(60, 60),
                  painter: ShoppingBagPainter(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Кастомный painter для иконки сумки
class ShoppingBagPainter extends CustomPainter {
  final Color color;

  ShoppingBagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Рисуем сумку (трапеция)
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(size.width * 0.9, size.height * 0.8)
      ..lineTo(size.width * 0.1, size.height * 0.8)
      ..close();

    canvas.drawPath(path, paint);

    // Рисуем ручку (полукруг)
    final handlePath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.05,
        size.width * 0.7,
        size.height * 0.2,
      );

    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(handlePath, handlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

