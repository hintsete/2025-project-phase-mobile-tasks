import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/core/presentation/routes/routes.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 12), () {
      if (!mounted) return;
      context.read<AuthBloc>().add(AuthLoadRequested());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadSuccess) {
            context.go(Routes.home);
          } else if (state is AuthLoadFailure) {
            context.go(Routes.login);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.cover,
            ),

            // Blue overlay with Opacity
            Opacity(
              opacity: 0.6,
              child: Container(
                color: Colors.blue,
              ),
            ),

            // Centered logo and text
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'ECOM',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ECOMMERCE APP',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
