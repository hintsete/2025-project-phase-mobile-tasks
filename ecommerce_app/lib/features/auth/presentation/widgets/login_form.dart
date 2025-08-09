import 'package:ecommerce_app/core/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email', style: labelStyle),
          const SizedBox(height: 6),
          Input(
            controller: _emailController,
            hint: 'ex: jon.smith@email.com',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            label: '',
          ),
          const SizedBox(height: 28),
          Text('Password', style: labelStyle),
          const SizedBox(height: 6),
          Input(
            controller: _passwordController,
            isPassword: true,
            hint: '********',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            label: '',
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoginInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Button(
                  text: 'SIGN IN',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login(context);
                    }
                  },
                  filled: true,      
                  color: Colors.blue,
                  borderRadius: 4,
                );
              },
            ),
          ),
          const SizedBox(height: 56),
          Center(
            child: TextButton(
              onPressed: () {
                context.go(Routes.register);
              },
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'SIGN UP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    context.read<AuthBloc>().add(
          AuthLoginRequested(_emailController.text, _passwordController.text),
        );
  }
}
