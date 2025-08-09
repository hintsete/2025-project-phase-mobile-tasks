import 'package:ecommerce_app/core/presentation/routes/routes.dart';
import 'package:ecommerce_app/core/presentation/widgets/snackbar.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/ecom_title.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';



class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          context.go(Routes.login);
          showInfo(context, 'Registered successfully');
        } else if (state is AuthRegisterFailure) {
          showError(context, state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Back arrow and EcomTitle in same row
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 18,color: Colors.blueAccent,),
                      onPressed: () => context.go(Routes.login),
                    ),
                    const Spacer(flex: 5,),
                    
                    Transform.scale(
                      scale: 0.8, // 80% of the original size
                      child: const EcomTitle(),
                    ),
                    // const Spacer(flex: 2), // keep EcomTitle slightly to right
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 32),
                const SignupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
