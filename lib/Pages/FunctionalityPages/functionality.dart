import 'package:flutter/cupertino.dart';

import '../HomePages/homeowner.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class PopUpFunctionalityPageWidget extends StatefulWidget {
  const PopUpFunctionalityPageWidget({Key? key}) : super(key: key);

  @override
  _PopUpFunctionalityPageWidgetState createState() =>
      _PopUpFunctionalityPageWidgetState();
}

class _PopUpFunctionalityPageWidgetState
    extends State<PopUpFunctionalityPageWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).lineColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: HomeAppTheme.of(context).primaryBtnText,
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon: Icon(Icons.arrow_back,
              color: CupertinoColors.systemGrey,),
            onPressed: () => Navigator.push(context,
                new MaterialPageRoute(builder: (context) => HomeownerHomePageWidget())),



            //aici trebuie un pop up cu do you want to exit the app
          ),
          centerTitle: false,
          elevation: 0,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Device Name',
                    style: HomeAppTheme.of(context).title1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://www.thelightbulb.co.uk/wp-content/uploads/2022/05/quick-guide-buying-best-light-bulbs-1.jpg',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: AutoSizeText(
                      'Device Info',
                      textAlign: TextAlign.center,
                      style: HomeAppTheme.of(context).subtitle2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Text(
                          'Charge',
                          style: HomeAppTheme.of(context).bodyText2,
                        ),
                      ),
                      Text(
                        '70%',
                        style: HomeAppTheme.of(context).subtitle1,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Text(
                          'Info',
                          style: HomeAppTheme.of(context).bodyText2,
                        ),
                      ),
                      Text(
                        'some value',
                        style: HomeAppTheme.of(context).subtitle1,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Text(
                          'Status',
                          style: HomeAppTheme.of(context).bodyText2,
                        ),
                      ),
                      Text(
                        'Good',
                        style: HomeAppTheme.of(context).subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Container(
                height: 200,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 40),
                      child: HomeAppButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Change',
                        options: HomeAppButtonOptions(
                          width: 110,
                          height: 50,
                          color: HomeAppTheme.of(context).tertiary400,
                          textStyle: HomeAppTheme.of(context)
                              .subtitle1
                              .override(
                            fontFamily: 'Poppins',
                            color:
                            HomeAppTheme.of(context).primaryBtnText,
                          ),
                          elevation: 3,
                          borderSide: const BorderSide(
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
    );
  }
}
