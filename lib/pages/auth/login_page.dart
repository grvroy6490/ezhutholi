import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/widgets/auth_form_header.dart';
import 'package:eluthozhi_v3/widgets/custom_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eluthozhi_v3/services/firebase_auth_service.dart';
import 'package:eluthozhi_v3/providers/login_state_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildInputField(String hint, bool isPassword) {
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
              controller: isPassword ? _passwordController : _emailController,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
              textCapitalization: isPassword? TextCapitalization.none : TextCapitalization.none,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your $hint';
                }
                if (!isPassword &&
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: getFigmaColor(context, 'Schemes', 'On Surface Variant'),
              ),
              onPressed: () {},
            ),
        ],
      ),
    );
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
                const SizedBox(height: 10),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: _buildLoginForm(),
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
      child: IntrinsicHeight(
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
                    _buildInputField('Email Address', false),
                    const SizedBox(height: 20),
                    _buildInputField('Password', true),
                    const SizedBox(height: 10),
                    _buildRememberRow(),
                    const SizedBox(height: 25),
                    CustomSubmitButton(onPressed: _handleLogin, text: 'Log in'),
                    const SizedBox(height: 15),
                    Text(
                      'Or',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color:
                            Provider.of<ThemeProvider>(context).isDark
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SocialLoginButton(
                      onPressed: () {},
                      text: 'Continue with Google',
                      icon: SvgPicture.asset(
                        'assets/images/google.svg', // Path to your SVG asset
                        width: 18.0, // Adjust width as needed
                        height: 18.0, // Adjust height as needed
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
            'Welcome back',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: getFigmaColor(context, 'Primary', 'Dark'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please enter your login credentials to access your account.',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: getFigmaColor(context, 'Primary', 'Main'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberRow() {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (val) {},
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
          color: Color.fromARGB(255, 217, 221, 223), // Adjust color as needed
          thickness: 1.0, // Adjust thickness as needed
          indent: 0.0, // Optional: Add indentation if needed
          endIndent: 0.0, // Optional: Add end indentation if needed
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: getFigmaColor(context, 'Secondary', 'Dark'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Signup');
              },
              child: Text(
                'Sign up',
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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        if (mounted) {
          Provider.of<LoginStateProvider>(context, listen: false).logIn();
          Navigator.pushReplacementNamed(context, '/Home');
        }
      } else {
        // Show error message
      }
    }
  }
}
