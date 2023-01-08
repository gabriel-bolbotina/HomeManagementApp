import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeownerHomePageWidget extends StatefulWidget {
  const HomeownerHomePageWidget({Key? key}) : super(key: key);

  @override
  _HomeownerHomePageWidgetState createState() =>
      _HomeownerHomePageWidgetState();
}

class _HomeownerHomePageWidgetState extends State<HomeownerHomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future addUserDetails (
      String firstName, String lastName, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'age': age,});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: CupertinoColors.systemGrey,),
            onPressed: () =>{ Navigator.pushReplacementNamed(
                context, 'homescreen')},
            //aici trebuie un pop up cu do you want to exit the app
          ),
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Hello, Xulescu',
            style: FlutterFlowTheme.of(context).title2.override(
              fontFamily: 'Poppins',
              color: FlutterFlowTheme.of(context).black600,
            ),
          ),

          centerTitle: false,
          elevation: 0,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.topRight,
                  child: Image.network(
                    'https://picsum.photos/seed/339/600',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                      child: Text(
                        'Devices',
                        style: FlutterFlowTheme.of(context).subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 190,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x230E151B),
                            offset: Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://www.thelightbulb.co.uk/wp-content/uploads/2022/05/quick-guide-buying-best-light-bulbs-1.jpg',
                                width: double.infinity,
                                height: 115,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                              child: Text(
                                'Device Name',
                                style: FlutterFlowTheme.of(context).subtitle1,
                              ),
                            ),
                            Expanded(
                              child: FFButtonWidget(
                                onPressed: () {
                                  addUserDetails("Andrei","Anton",23);
                                  print('Button pressed ...');
                                },
                                text: 'Details',
                                options: FFButtonOptions(
                                  width: 80,
                                  height: 40,
                                  color: const Color.fromARGB(255, 128, 173, 242),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 190,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x230E151B),
                            offset: Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://i.pinimg.com/736x/b8/be/cb/b8becbabf3d406035aa1611245e8f6c2.jpg',
                                width: double.infinity,
                                height: 115,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                              child: Text(
                                'Device Name',
                                style: FlutterFlowTheme.of(context).subtitle1,
                              ),
                            ),
                            Expanded(
                              child: FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Details',
                                options: FFButtonOptions(
                                  width: 80,
                                  height: 40,
                                  color: const Color.fromARGB(255, 128, 173, 242),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 190,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x230E151B),
                            offset: Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1527352774566-e4916e36c645?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8b3V0c2lkZSUyMHRoZSUyMHdpbmRvd3xlbnwwfHwwfHw%3D&w=1000&q=80',
                                width: double.infinity,
                                height: 115,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                              child: Text(
                                'Device Name',
                                style: FlutterFlowTheme.of(context).subtitle1,
                              ),
                            ),
                            Expanded(
                              child: FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'Details',
                                options: FFButtonOptions(
                                  width: 80,
                                  height: 40,
                                  color: const Color.fromARGB(255, 128, 173, 242),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(260, 140, 0, 0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: '+ Add',
                  options: FFButtonOptions(
                    width: 100,
                    height: 50,
                    color: const Color.fromARGB(255, 253, 238, 186),
                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: 20,
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
