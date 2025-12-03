import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool showShapes;

  const AuthBackground({
    super.key,
    required this.child,
    this.showShapes = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Gradient Overlay (Optional, for more depth)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
          ),

          if (showShapes) ...[
            // Background shapes
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height * 0.2,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/icons/shapes png-02.png',
                  height: 200,
                  errorBuilder: (c, e, s) => const SizedBox(),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.25,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/icons/shapes png-03.png',
                  height: 200,
                  errorBuilder: (c, e, s) => const SizedBox(),
                ),
              ),
            ),
          ],

          // Content
          SafeArea(child: child),
        ],
      ),
    );
  }
}
