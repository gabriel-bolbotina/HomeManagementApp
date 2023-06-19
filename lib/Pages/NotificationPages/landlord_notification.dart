import 'package:flutter/cupertino.dart';

import '../ProfilePages/homeowner_profile.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/homeAppWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandlordNotificationSettingsWidget extends StatefulWidget {
  const LandlordNotificationSettingsWidget({Key? key}) : super(key: key);

  @override
  _LandlordNotificationSettingsWidgetState createState() =>
      _LandlordNotificationSettingsWidgetState();
}

class _LandlordNotificationSettingsWidgetState
    extends State<LandlordNotificationSettingsWidget> {
  bool? switchListTileValue1;
  bool? switchListTileValue2;
  bool? switchListTileValue3;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).lineColor,
      appBar: AppBar(
        backgroundColor: HomeAppTheme.of(context).lineColor,
        automaticallyImplyLeading: false,
        leading:IconButton(
          icon: const Icon(Icons.arrow_back,
            color: CupertinoColors.systemGrey,),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeownerProfilePageWidget())),
        ),
        title: Text(
          'Back',
          style: HomeAppTheme.of(context).title2.override(
            fontFamily: 'Poppins',
            color: HomeAppTheme.of(context).gray600,
            fontSize: 18,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Choose what notifcations you want to recieve below and we will update the settings.',
                      style: HomeAppTheme.of(context).bodyText2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: SwitchListTile.adaptive(
              value: switchListTileValue1 ??= true,
              onChanged: (newValue) async {
                setState(() => switchListTileValue1 = newValue!);
              },
              title: Text(
                'Push Notifications',
                style: HomeAppTheme.of(context).title3,
              ),
              subtitle: Text(
                'Receive Push notifications from our application on a semi regular basis.',
                style: HomeAppTheme.of(context).bodyText2,
              ),
              activeColor: HomeAppTheme.of(context).primaryColor,
              activeTrackColor: const Color(0x8A4B39EF),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
            ),
          ),
          SwitchListTile.adaptive(
            value: switchListTileValue2 ??= true,
            onChanged: (newValue) async {
              setState(() => switchListTileValue2 = newValue!);
            },
            title: Text(
              'Email Notifications',
              style: HomeAppTheme.of(context).title3,
            ),
            subtitle: Text(
              'Receive email notifications from our marketing team about new features.',
              style: HomeAppTheme.of(context).bodyText2,
            ),
            activeColor: const Color(0xFF4B39EF),
            activeTrackColor: const Color(0xFF3B2DB6),
            dense: false,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
          ),
          SwitchListTile.adaptive(
            value: switchListTileValue3 ??= true,
            onChanged: (newValue) async {
              setState(() => switchListTileValue3 = newValue!);
            },
            title: Text(
              'Location Services',
              style: HomeAppTheme.of(context).title3,
            ),
            subtitle: Text(
              'Allow us to track your location, this helps keep track of spending and keeps you safe.',
              style: HomeAppTheme.of(context).bodyText2,
            ),
            activeColor: const Color(0xFF4B39EF),
            activeTrackColor: const Color(0xFF3B2DB6),
            dense: false,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
          ),
        ],
      ),
    );
  }
}
