import 'package:eluthozhi_v3/constants/color_scheme_data.dart';
import 'package:eluthozhi_v3/models/color_scheme_model.dart';
import 'package:eluthozhi_v3/pages/auth/login_page.dart';
import 'package:eluthozhi_v3/pages/auth/sign_up_page.dart';
import 'package:eluthozhi_v3/pages/language_page.dart';
import 'package:eluthozhi_v3/pages/settings_page.dart';
import 'package:eluthozhi_v3/pages/splash_page.dart';
import 'package:eluthozhi_v3/providers/button_style_provider.dart';
import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eluthozhi_v3/providers/login_state_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ButtonStyleProvider()),
        ChangeNotifierProvider(create: (_) => LoginStateProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Eluthozhi',
            theme: getTheme(false),
            darkTheme: getTheme(true),
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            routes: {
              '/Login': (context) => const LoginPage(),
              '/Signup': (context) => const SignUpPage(),
              '/Home': (context) => LanguagePage(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashPage();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        debugPrint('AuthWrapper: ${snapshot.connectionState}');
        // User is logged in
        if (snapshot.hasData) {
          return LanguagePage();
        }

        // User is NOT logged in
        return const LoginPage();
      },
    );
  }
}
