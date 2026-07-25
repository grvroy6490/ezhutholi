import 'package:eluthozhi_v3/services/firebase_auth_service.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = FirebaseAuthService();
  bool _isSubmitting = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await _authService.sendPasswordResetEmail(_emailController.text);
      if (!mounted) return;
      setState(() => _emailSent = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(FirebaseAuthService.messageFor(e))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Surface', 'Surface Dim'),
      appBar: AppBar(
        backgroundColor: getFigmaColor(context, 'Surface', 'Surface Bright'),
        foregroundColor: getFigmaColor(context, 'Primary', 'Dark'),
        title: const Text('Reset password'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _emailSent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check your email',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: getFigmaColor(context, 'Primary', 'Dark'),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a password reset link to ${_emailController.text.trim()}.',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: getFigmaColor(context, 'Secondary', 'Main'),
                        ),
                  ),
                  const SizedBox(height: 24),
                  CustomSubmitButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Back to login',
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your account email and we will send you a reset link.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: getFigmaColor(context, 'Secondary', 'Main'),
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomSubmitButton(
                      onPressed: _isSubmitting ? null : _handleReset,
                      text: _isSubmitting ? 'Sending...' : 'Send reset link',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
