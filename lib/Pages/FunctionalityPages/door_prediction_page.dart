import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../flutter_flow/HomeAppTheme.dart';
import 'door_prediction_widget.dart'; // Import the widget we created

class DoorPredictionPageWidget extends StatefulWidget {
  const DoorPredictionPageWidget({Key? key}) : super(key: key);

  @override
  State<DoorPredictionPageWidget> createState() =>
      _DoorPredictionPageWidgetState();
}

class _DoorPredictionPageWidgetState extends State<DoorPredictionPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).primaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: HomeAppTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: CupertinoColors.systemGrey,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Door Lock Predictor',
            style: HomeAppTheme.of(context).title2.override(
                  fontFamily: 'Lexend Deca',
                  color: HomeAppTheme.of(context).primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: const DoorPredictionWidget(), // Use our custom widget
    );
  }
}
