import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/widgets/auth_form_header.dart';
import 'package:eluthozhi_v3/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/auth_bg.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const AuthLogoHeader(),
                const SizedBox(height: 30),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: _buildLoginForm(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Card(
      margin: EdgeInsets.zero,
      color: getFigmaColor(context, 'Surface', 'Surface Dim'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildInputField('Name', _nameController, false),
                  const SizedBox(height: 20),
                  _buildInputField('Email', _emailController, false),
                  const SizedBox(height: 20),
                  _buildInputField('Password', _passwordController, true),
                  const SizedBox(height: 10),
                  _buildRememberRow(),
                  const SizedBox(height: 25),
                  CustomSubmitButton(
                    onPressed: _handleSignup,
                    text: 'Signup',
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Or',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Provider.of<ThemeProvider>(context).isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                  const SizedBox(height: 15),
                  SocialLoginButton(
                    onPressed: () {},
                    text: 'Continue with Google',
                    icon: SvgPicture.asset(
                      'assets/images/google.svg',
                      width: 18.0,
                      height: 18.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSignupRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: getFigmaColor(context, 'Surface', 'Surface Bright'),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            offset: const Offset(0, 5),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Join us!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: getFigmaColor(context, 'Primary', 'Dark'),
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Create your account to get started.',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: getFigmaColor(context, 'Primary', 'Main'),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String hint, TextEditingController controller, bool isPassword) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: getFigmaColor(context, 'Surface', 'Surface Container'),
        border: Border(
          bottom: BorderSide(
            color: getFigmaColor(context, 'Schemes', 'On Surface'),
            width: 1.0,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword ? _obscurePassword : false,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$hint cannot be empty';
                }

                if (hint == 'Email') {
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                }

                if (isPassword && value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: getFigmaColor(context, 'Schemes', 'On Surface Variant'),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRememberRow() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (val) {
            setState(() {
              _rememberMe = val ?? false;
            });
          },
          checkColor: getFigmaColor(context, 'Grey', 'Grey'),
          activeColor: getFigmaColor(context, 'Primary', 'Main'),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          'Remember me',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: getFigmaColor(context, 'Secondary', 'Main'),
              ),
        ),
        const Spacer(),
        TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/ForgotPassword');
          },
          child: Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: getFigmaColor(context, 'Primary', 'Main'),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupRow() {
    return Column(
      children: [
        Divider(
          color: const Color.fromARGB(255, 217, 221, 223),
          thickness: 1.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: getFigmaColor(context, 'Secondary', 'Dark'),
                  ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Login');
              },
              child: Text(
                'Login here',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: getFigmaColor(context, 'Secondary', 'Dark'),
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating account...')),
      );

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/Home');
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        String errorMsg = 'Something went wrong';
        if (e.code == 'email-already-in-use') {
          errorMsg = 'This email is already registered.';
        } else if (e.code == 'weak-password') {
          errorMsg = 'Password should be at least 6 characters.';
        } else if (e.code == 'invalid-email') {
          errorMsg = 'Invalid email address.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
    }
  }
}
