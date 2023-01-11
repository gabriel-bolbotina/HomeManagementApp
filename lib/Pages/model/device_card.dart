import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'Devices.dart';

class DeviceCard extends StatelessWidget{
  final Device _device;

  DeviceCard(this._device);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
               _device.uploadedImage! ,
                width: double.infinity,
                height: 115,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
              child: Text(
                _device.deviceName!,
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
    );
  }
}