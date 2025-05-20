import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_well/providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'Register',
                    style: Theme.of(context).textTheme.headlineLarge

                ),
                const SizedBox(height: 32),
                _buildLabel("Username"),
                _buildInputField(controller: _nameController),
                const SizedBox(height: 16),
                _buildLabel("Email"),
                _buildInputField(controller: _emailController),
                const SizedBox(height: 16),
                _buildLabel("Password"),
                _buildInputField(
                  controller: _passwordController,
                  obscure: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      authProvider.register(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                         _passwordController.text,
                      );
                    },

                    child:
                        authProvider.isLoading
                            ?  CircularProgressIndicator(
                              color: AppColors.myWhite,
                            )
                            : const Text(
                              'Submit',

                            ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    );
                  },
                  child: Text(
                    "Already have an account?",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.myGreen)

                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,                   style: Theme.of(context).textTheme.bodyMedium
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,

      ),
      style: Theme.of(context).textTheme.bodyMedium
    ,
    );
  }
}
