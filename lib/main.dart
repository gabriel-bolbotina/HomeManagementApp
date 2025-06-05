import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeapp/Pages/Register/Address.dart';
import 'package:homeapp/Pages/Register/Photo.dart';

import 'Pages/HomePages/homeowner.dart';
import 'Pages/LoginPage/login_riverpod.dart';
import 'Pages/Register/Register.dart';
import 'Pages/StartingPages/startPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'providers/navigation_provider.dart';
import 'Pages/ClimatePages/climate_control_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();
  await dotenv.load(
      fileName: "/Users/gabrielbolbotina/repos/homemanagementapp/.env");

  runApp(
    const ProviderScope(
      child: HomeApp(),
    ),
  );
}

class HomeApp extends ConsumerWidget {
  const HomeApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home-App',
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: Typography.blackCupertino,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AppRouter(),
        '/login': (context) => const LoginPageWidget(),
        '/homescreen': (context) => const HomePageWidget(),
        '/register_screen': (context) => const RegisterPageWidget(),
        '/address_screen': (context) => const Address(fromRegister: true),
        '/homeowner_main': (context) => const HomeownerHomePageWidget(),
        '/tenant_main': (context) => const HomeownerHomePageWidget(), // All users go to same screen
        '/landlord_main': (context) => const HomeownerHomePageWidget(), // All users go to same screen
        '/photo_screen': (context) => const AddPhotoWidget(),
        '/address_update': (context) => const Address(
              fromRegister: false,
            ),
        '/climate_control': (context) => const ClimateControlPage(),
      },
    );
  }

}

class AppRouter extends ConsumerWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowLoading = ref.watch(shouldShowLoadingProvider);
    final navigationRoute = ref.watch(navigationRouteProvider);
    final authError = ref.watch(authErrorProvider);
    final authState = ref.watch(authNotifierProvider);

    // Show error if there is one
    if (authError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(context, authError, ref);
      });
    }

    // Show loading screen while auth operations are in progress
    if (shouldShowLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Navigate based on the determined route
    return _getWidgetForRoute(navigationRoute);
  }

  Widget _getWidgetForRoute(String route) {
    switch (route) {
      case '/homescreen':
        return const HomePageWidget();
      case '/login':
        return const LoginPageWidget();
      case '/homeowner_main':
        return const HomeownerHomePageWidget();
      default:
        return const HomePageWidget();
    }
  }

  void _showErrorDialog(BuildContext context, String error, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authNotifierProvider.notifier).clearError();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
