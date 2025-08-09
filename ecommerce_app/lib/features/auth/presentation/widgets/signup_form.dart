import 'package:ecommerce_app/core/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/button.dart';
import '../../../../core/presentation/widgets/input.dart';
import '../bloc/auth_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Input(
            controller: _nameController,
            hint: 'ex: jon smith',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            label: '',
          ),
          const SizedBox(height: 24),
          Text(
            'Email',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Input(
            controller: _emailController,
            hint: 'ex: jon.smith@email.com',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            label: '',
          ),
          const SizedBox(height: 24),
          Text(
            'Password',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Input(
            controller: _passwordController,
            isPassword: true,
            hint: '********',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            label: '',
          ),
          const SizedBox(height: 24),
          Text(
            'Confirm password',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Input(
            controller: _confirmPasswordController,
            isPassword: true,
            hint: '********',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            label: '',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
                side: BorderSide(
                  color: Colors.blueAccent, // Border color when unchecked
                  width: 2.0,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'I understood the ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'terms',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blueAccent,
                          ),
                    ),
                    TextSpan(
                      text: ' & ',
                      // style: Theme.of(context).textTheme.bodyMedium,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blueAccent,
                          ),
                      
                    ),
                    TextSpan(
                      text: 'policy',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blueAccent,
                          ),
                    ),
                    TextSpan(
                      text: '.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthRegisterInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Button(
                  text: 'SIGN UP',
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _termsAccepted) {
                      _register(context);
                    } else if (!_termsAccepted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please accept the terms & policy'),
                        ),
                      );
                    }
                  },
                  filled: true,      
                  color: Colors.blue,
                  borderRadius: 4,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {
                context.go(Routes.login);
              },
              child: RichText(
                text: TextSpan(
                  text: "Have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'SIGN IN',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.blue,
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) {
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}