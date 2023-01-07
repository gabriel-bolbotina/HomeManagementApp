import '../../Services/authentification.dart';
import '../StartingPages/startPage.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeapp/Services/FirebaseService.dart';
//import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  TextEditingController? emailAddressController;
  TextEditingController? passwordLoginController;

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isloading = false;

  late bool passwordLoginVisibility;
  late bool emailAddressVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    emailAddressController = TextEditingController();
    passwordLoginController = TextEditingController();
    passwordLoginVisibility = false;
    emailAddressVisibility = false;
  }

  @override
  void dispose() {
    emailAddressController?.dispose();
    passwordLoginController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: FlutterFlowTheme
              .of(context)
              .primaryBtnText,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(-0.3, -0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.1, -0.1),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 50,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: FlutterFlowTheme
                                .of(context)
                                .gray600,
                            size: 24,
                          ),
                          onPressed: () async {
                            //context.pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                        child: Text(
                          'Back',
                          style: FlutterFlowTheme
                              .of(context)
                              .title1
                              .override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme
                                .of(context)
                                .gray600,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                    child: Text(
                      'Access your account by logging in below.',
                      style: FlutterFlowTheme
                          .of(context)
                          .subtitle2
                          .override(
                        fontFamily: 'Outfit',
                        color: Color(0xFF57636C),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Color(0x4D101213),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: emailAddressController,
                maxLines: 1,
                obscureText: !emailAddressVisibility,
                //obscureText: !emailAddressVisibility,
                decoration: InputDecoration(
                  labelText: 'Your email address...',
                  labelStyle: FlutterFlowTheme
                      .of(context)
                      .bodyText2
                      .override(
                    fontFamily: 'Outfit',
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Enter your email...',
                  hintStyle: FlutterFlowTheme
                      .of(context)
                      .bodyText1
                      .override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                ),
                style: FlutterFlowTheme
                    .of(context)
                    .bodyText1
                    .override(
                  fontFamily: 'Outfit',
                  color: Color(0xFF0F1113),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                expands:  false,

              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Color(0x4D101213),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: passwordLoginController,
                obscureText: !passwordLoginVisibility,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: FlutterFlowTheme
                      .of(context)
                      .bodyText2
                      .override(
                    fontFamily: 'Outfit',
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Please enter your password...',
                  hintStyle: FlutterFlowTheme
                      .of(context)
                      .bodyText1
                      .override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                  suffixIcon: InkWell(
                    onTap: () =>
                        setState(
                              () =>
                          passwordLoginVisibility = !passwordLoginVisibility,
                        ),
                    focusNode: FocusNode(skipTraversal: true),
                    child: Icon(
                      passwordLoginVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(0xFF57636C),
                      size: 22,
                    ),
                  ),
                ),
                style: FlutterFlowTheme
                    .of(context)
                    .bodyText1
                    .override(
                  fontFamily: 'Outfit',
                  color: Color(0xFF0F1113),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                expands: false,
              ),
            ),
          ),




          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child: FFButtonWidget(
              //implementam cu firebase

              onPressed: () { print("hey");},
            /*async {
            if (_formKey.currentState!.validate()) {
            setState(() {
            isloading = true;
            });
            try {
            await _auth.signInWithEmailAndPassword(
            email: (emailAddressController!.text), password: (passwordLoginController!.text));

            await Navigator.of(context).push(
            MaterialPageRoute(
            builder: (contex) => HomePageWidget(),
            ),
            );
            setState(() {
            isloading = false;
            });
            } on FirebaseAuthException catch (e) {
            showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
            title: Text("Ops! Login Failed"),
            content: Text('${e.message}'),
            actions: [
            TextButton(
            onPressed: () {
            Navigator.of

            (ctx).pop();
            },
            child: Text('Okay'),

            )
            ],
            ),
            );
            print(e);


            }
            }
            },
              /*async {
    GoRouter.of(context).prepareAuthEvent();

    final user = await signInWithEmail(
    context,
    emailAddressController!.text,
    passwordLoginController!.text,
    );
    if (user == null) {
    return;
    }

    context.goNamedAuth('', mounted);
    },
    */
    */

              text: 'Login',
              options: FFButtonOptions(
                width: 270,
                height: 50,
                color: FlutterFlowTheme
                    .of(context)
                    .tertiary400,
                textStyle: FlutterFlowTheme
                    .of(context)
                    .subtitle2
                    .override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme
                      .of(context)
                      .primaryBtnText,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                elevation: 3,
                borderSide: BorderSide(
                  width: 1,
                ),
                borderRadius: 20,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child:
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () async {
                      setState(() {
                        isloading = true;
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
                        isloading = false;
                      });
                    },

    )
    ),




          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
            child: FFButtonWidget(


              onPressed: () {
                print('Button-Login pressed ...');
              },
              text: 'Forgot Password?',
              options: FFButtonOptions(
                width: 170,
                height: 50,
                color: Color(0xFFF1F4F8),
                textStyle: FlutterFlowTheme
                    .of(context)
                    .subtitle2
                    .override(
                  fontFamily: 'Outfit',
                  color: Color(0xFF57636C),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                elevation: 0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),


            ),
          ),
        ],
      ),
    );
  }

  void showMessage(String s) {
    print(s);
  }


}
