import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:homeapp/Pages/LoginPage/login_riverpod.dart';
import 'package:homeapp/Pages/Register/Register.dart';
import 'package:homeapp/services/authentication.dart';
import 'package:rive/rive.dart';

import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Route _createRoute(String type) {
    if (type == "login") {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LoginPageWidget(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutSine;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    } else if (type == "register") {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RegisterPageWidget(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutSine;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePageWidget(),
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

  @override
  Widget build(BuildContext context) {
    bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
      (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              selectionColor: CupertinoColors.systemGrey,
            ),
            content: new Text(
              'Do you want to exit an App',
              selectionColor: CupertinoColors.systemGrey,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          );
      return true;
    }

    @override
    void initState() {
      super.initState();
      BackButtonInterceptor.add(myInterceptor);
    }

    @override
    void dispose() {
      BackButtonInterceptor.remove(myInterceptor);
      super.dispose();
    }

    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text(
                'Are you sure?',
                selectionColor: CupertinoColors.systemGrey,
              ),
              content: new Text(
                'Do you want to exit an App',
                selectionColor: CupertinoColors.systemGrey,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).primaryBackground,
      /*appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(

          backgroundColor: FlutterFlowTheme
              .of(context)
              .primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Home App',
            style: FlutterFlowTheme
                .of(context)
                .title2
                .override(
              fontFamily: 'Poppins',
              color: FlutterFlowTheme
                  .of(context)
                  .primaryBackground,
              fontSize: 22,
            ),
          ),
          actions: [],
          centerTitle: false,

        ),
      ),

         */
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(children: [
            const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 9, 0),
                child: RiveAnimation.asset('assets/images/new_file.riv')),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                      alignment: AlignmentDirectional(0, 0.8),
                      child: Image.asset("assets/images/iconapp.png",
                          scale: 0.01)),
                ),
                Align(
                  alignment: AlignmentDirectional(0, -0.5),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: HomeAppButtonWidget(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute("login"));
                      },
                      text: 'Login',
                      options: HomeAppButtonOptions(
                        width: 200,
                        height: 45,
                        color: HomeAppTheme.of(context).primaryColor,
                        textStyle: HomeAppTheme.of(context).subtitle1.override(
                            fontFamily: 'Fira Sans',
                            color: HomeAppTheme.of(context).primaryText,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 25,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -0.95),
                    child: HomeAppButtonWidget(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute("register"));
                      },
                      text: 'Register',
                      options: HomeAppButtonOptions(
                        width: 120,
                        height: 40,
                        color: const Color.fromARGB(255, 255, 242, 176),
                        textStyle: HomeAppTheme.of(context).subtitle2.override(
                              fontFamily: 'Fira Sans',
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              color: HomeAppTheme.of(context).primaryText,
                              fontSize: 12,
                            ),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
