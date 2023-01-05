import 'package:homeapp/Pages/LoginPage/Login.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme
          .of(context)
          .primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: FlutterFlowTheme
              .of(context)
              .primaryBtnText,
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
                  .gray600,
              fontSize: 22,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                    child: SelectionArea(
                        child: Text(
                          'Home',
                          style: FlutterFlowTheme
                              .of(context)
                              .title1
                              .override(
                            fontFamily: 'Poppins',
                            fontSize: 36,
                          ),
                        )),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -0.5),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, 'login_screen');},
                      text: 'Login',
                    options: FFButtonOptions(
                      width: 200,
                      height: 45,
                      color: FlutterFlowTheme
                          .of(context)
                          .primaryColor,
                      textStyle: FlutterFlowTheme
                          .of(context)
                          .subtitle1
                          .override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryBtnText,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
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
                  child: FFButtonWidget(
                    onPressed: () {
                      MaterialPageRoute(
                          builder: (context) => LoginPageWidget()
                      );
                    },
                    text: 'Register',
                    options: FFButtonOptions(
                      width: 120,
                      height: 40,
                      color: FlutterFlowTheme
                          .of(context)
                          .secondaryColor,
                      textStyle: FlutterFlowTheme
                          .of(context)
                          .subtitle2
                          .override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme
                            .of(context)
                            .primaryBtnText,
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
        ),
      ),
    );
  }
}


