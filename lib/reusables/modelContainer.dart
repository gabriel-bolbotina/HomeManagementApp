import 'package:flutter/material.dart';
import '../Pages/flutter_flow/HomeAppTheme.dart';
import '../Pages/FunctionalityPages/door_prediction_page.dart';

class PredictionContainer extends StatelessWidget {
  const PredictionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DoorPredictionPageWidget(),
        ),
      ),
      child: Container(
        width: size.width * 0.4,
        height: size.height * 0.13,
        decoration: BoxDecoration(
          color: HomeAppTheme.of(context).primaryColor.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.analytics_outlined,
              size: 30.0,
              color: Colors.black54,
            ),
            SizedBox(height: 16.0, width: 39),
            Text(
              'Door Predictor',
              style: HomeAppTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
