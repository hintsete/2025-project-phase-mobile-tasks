import 'package:ecommerce_app/core/presentation/routes/routes.dart';
import 'package:ecommerce_app/core/presentation/widgets/snackbar.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/ecom_title.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          context.go(Routes.home);
          showInfo(context, 'Logged in successfully');
        } else if (state is AuthLoginFailure) {
          showError(context, state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  SizedBox(height: 18,),
                  EcomTitle(),
                  SizedBox(height: 32),
                  Text(
                    'Sign into your account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
