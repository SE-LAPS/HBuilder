import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../main/main_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late Timer _timer;
  String _timeString = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('h:mm').format(now);
    if (mounted) {
      setState(() {
        _timeString = formattedTime;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6B00), // Orange matching theme
      body: Stack(
        children: [
          // Background shapes
          Positioned(
            left: 0,
            top: 200,
            child: Image.asset('assets/icons/shapes png-02.png', height: 200),
          ),
          Positioned(
            right: 0,
            top: 200,
            child: Image.asset('assets/icons/shapes png-03.png', height: 200),
          ),

          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Top Bar with Time/Language
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$_timeString  SL',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(flex: 1),

                          // Rotated Logo
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image.asset(
                                'assets/logos/Washtron Orange BG Without tagline -01.png',
                                height:
                                    constraints.maxHeight *
                                    0.55, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const Spacer(flex: 1),

                          // Welcome Text
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Description
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Indicators (dots)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDot(false),
                              _buildDot(true),
                              _buildDot(false),
                            ],
                          ),

                          SizedBox(height: 30.h),

                          // Log in Button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  _showLoginSheet(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFF6B00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Bottom Divider
                          Container(
                            width: 150.w,
                            height: 1,
                            color: Colors.white70,
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        border: isActive ? null : Border.all(color: Colors.white, width: 1),
      ),
    );
  }

  void _showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<AuthProvider>(
        builder: (context, authProvider, _) => Container(
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 24.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),

                SizedBox(height: 16.h),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),

                SizedBox(height: 24.h),

                // Error Message
                if (authProvider.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Email Sign In Button
                SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Sign In with Email',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 20.h),

                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400])),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400])),
                  ],
                ),

                SizedBox(height: 20.h),

                // Google Sign In Button
                SizedBox(
                  height: 50.h,
                  child: ElevatedButton.icon(
                    onPressed: authProvider.isLoading
                        ? null
                        : _signInWithGoogle,
                    icon: Image.asset(
                      'assets/icons/google_icon.png',
                      height: 24.sp,
                      width: 24.sp,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.g_mobiledata,
                        size: 24.sp,
                        color: Colors.red,
                      ),
                    ),
                    label: Text(
                      'Sign In with Google',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFFFF6B00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }

  Future<void> _signInWithGoogle() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }
}
