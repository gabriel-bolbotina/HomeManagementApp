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
                      print('Button pressed ...');
                    },
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
                      print('Button pressed ...');
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

/*
class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
  }

  class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return  !isLoading? SizedBox(
  height: 40,
  width: size.width,
  child: OutlinedButton.icon(
  icon: Icon(
  Icons.account_box,
  color: kPrimaryColor,
  ),
  onPressed: () async {
  setState(() {
  isLoading = true;
  });
  FirebaseService service = new FirebaseService();
  try {
  await service.signInwithGoogle();
  Navigator.pushNamedAndRemoveUntil(context, 'homescreen', (route) => false);
  } catch(e){
  if(e is FirebaseAuthException){
  showMessage(e.message!);
  }
  }
  setState(() {
  isLoading = false;
  });
  },
  label: Text(
  "Sign In With Google",
  style: TextStyle(
  color: Colors.white, fontWeight: FontWeight.bold),
  ),
  style: ButtonStyle(
  backgroundColor:
  MaterialStateProperty.all<Color>(kPrimaryColor),
  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
  ),
  ) : CircularProgressIndicator();
  }

  void showMessage(String message) {
  showDialog(
  context: context,
  builder: (BuildContext context) {
  return AlertDialog(
  title: Text("Error"),
  content: Text(message),
  actions: [
  TextButton(
  child: Text("Ok"),
  onPressed: () {
  Navigator.of(context).pop();
  },
  )
  ],
  );
  });
  }

  }
*/
