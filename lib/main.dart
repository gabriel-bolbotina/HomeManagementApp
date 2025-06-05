import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeapp/Pages/EditPages/homeowner_edit.dart';
import 'package:homeapp/Pages/HomePages/landlord.dart';
import 'package:homeapp/Pages/HomePages/tenant.dart';
import 'package:homeapp/Pages/Register/Address.dart';
import 'package:homeapp/Pages/Register/ChooseRole.dart';
import 'package:homeapp/Pages/Register/Photo.dart';
import 'Pages/FunctionalityPages/functionality.dart';

import 'Pages/HomePages/homeowner.dart';
import 'Pages/LoginPage/Login.dart';
import 'Pages/Register/ChooseRole.dart';
import 'Pages/Register/Register.dart';
import 'Pages/Requests/ReceivedRequest.dart';
import 'Pages/StartingPages/startPage.dart';
import 'Pages/flutter_flow/HomeAppTheme.dart';
import 'Services/authentication.dart';
import 'package:dcdg/dcdg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();
  await dotenv.load(
      fileName: "/Users/gabrielbolbotina/repos/homemanagementapp/.env");

  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  Authentication _authentication = Authentication();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home-App',
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: Typography.blackCupertino,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const HomePageWidget();
            }
            if (userSnapshot.hasData) {
              _authentication.getProfileImage();

              if (_authentication.getUserRole() == "homeowner") {
                return const HomeownerHomePageWidget();
              } else if (_authentication.getUserRole() == "tenant") {
                return const TenantHomePageWidget();
              } else if (_authentication.getUserRole() == "landlord") {
                return LandlordHomePageWidget();
              } else
                return HomePageWidget();
            }

            return HomePageWidget();
          }),
      routes: {
        'homescreen': (context) => HomePageWidget(),
        'login_screen': (context) => LoginPageWidget(),
        'register_screen': (context) => RegisterPageWidget(),
        'role_screen': (context) => ChooseRoleWidget(),
        'address_screen': (context) => Address(
              fromRegister: true,
            ),
        'homeowner_main': (context) => HomeownerHomePageWidget(),
        'tenant_main': (context) => TenantHomePageWidget(),
        'landlord_main': (context) => LandlordHomePageWidget(),
        'photo_screen': (context) => AddPhotoWidget(),
        'address_update': (context) => Address(
              fromRegister: false,
            ),
      },
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LoginPageWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
