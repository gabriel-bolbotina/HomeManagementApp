import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'Pages/flutter_flow/flutter_flow_theme.dart';
import 'Services/authentification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp (MyApp ()) ;

}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home-App',
      theme: ThemeData(
        primaryColor: FlutterFlowTheme.of(context).gray600,
        textTheme:  Theme.of(context).textTheme.apply(bodyColor: FlutterFlowTheme.of(context).gray600),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),


      home:  StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const HomePageWidget();
            }
            if (userSnapshot.hasData) {
              return const ChooseRoleWidget();
            }
            return const HomePageWidget();
          }
      ),


      routes: {
        'homescreen': (context) => HomePageWidget(),
        'login_screen': (context) => LoginPageWidget(),
        'register_screen': (context) =>RegisterPageWidget(),
        'role_screen': (context) =>ChooseRoleWidget(),
        'address_screen': (context) => Address(),
        'homeowner_main': (context) => HomeownerHomePageWidget(),
        'tenant_main': (context) => TenantHomePageWidget(),
        'landlord_main': (context) => LandlordHomePageWidget(),
        'photo_screen': (context) => AddPhotoWidget(),

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

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}

