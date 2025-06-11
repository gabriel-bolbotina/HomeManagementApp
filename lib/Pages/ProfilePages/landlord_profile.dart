import 'package:flutter/cupertino.dart';

import '../../services/FirebaseService.dart';
import '../EditPages/landlord_edit.dart';
import '../HomePages/landlord.dart';
import '../NotificationPages/landlord_notification.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordProfilePageWidget extends StatefulWidget {
  const LandlordProfilePageWidget({Key? key}) : super(key: key);

  @override
  _LandlordProfilePageWidgetState createState() =>
      _LandlordProfilePageWidgetState();
}

class _LandlordProfilePageWidgetState
    extends State<LandlordProfilePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future signOut() async {
    return (await showDialog(
        context: context,
        builder: (context) =>
        AlertDialog(
            title: const Text('Are you sure you want to exit the app?',
              style: TextStyle(color: CupertinoColors.systemGrey,
                fontFamily: 'Lexend Deca',

              ),

              selectionColor: CupertinoColors.systemGrey,
            ),
            backgroundColor: Colors.white,
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  FirebaseService service = FirebaseService();
                  await service.signOutFromGoogle();

                  Navigator.pushReplacementNamed(context, '/homescreen');
                },
                child: const Text('OK'),
              ),
            ]
        )
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).lineColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: HomeAppTheme.of(context).lineColor,
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon: const Icon(Icons.arrow_back,
              color: CupertinoColors.systemGrey,),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LandlordHomePageWidget())),
          ),
          centerTitle: false,
          elevation: 0,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
            padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    decoration: BoxDecoration(
                      color: HomeAppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: HomeAppTheme.of(context).secondaryBackground,
                        width: 0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Profile',
                            style: HomeAppTheme.of(context).subtitle2,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                              color: CupertinoColors.systemGrey,
                              size:  20,),
                            onPressed: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const LandlordEditPageWidget())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    decoration: BoxDecoration(
                      color: HomeAppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: HomeAppTheme.of(context).secondaryBackground,
                        width: 0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notification Settings',
                            style: HomeAppTheme.of(context).subtitle2,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                              color: CupertinoColors.systemGrey,
                              size:  20,),
                            onPressed: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const LandlordNotificationSettingsWidget ())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, -0.15),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 280, 0, 0),
              child: HomeAppButtonWidget(
                onPressed: () => signOut(),

                text: 'Log Out',
                options: HomeAppButtonOptions(
                  width: 110,
                  height: 50,
                  color: const Color.fromARGB(255, 253, 238, 186),
                  textStyle: HomeAppTheme.of(context).subtitle1.override(
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                  elevation: 3,
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
    );
  }
}
