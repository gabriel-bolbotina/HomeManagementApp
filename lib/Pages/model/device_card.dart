import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'Devices.dart';

class DeviceCard extends StatelessWidget {
  final Device _device;

  const DeviceCard(this._device, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        child: Container(
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
            child: Stack(
                alignment: AlignmentDirectional.topStart,
                textDirection: TextDirection.ltr,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _device.uploadedImage!,
                      width: double.infinity,
                      height: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    constraints: const BoxConstraints.tightFor(width: 100, height: 400),
                    child:
                    Padding(

                      padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                    child: Text(
                      _device.deviceName!,
                      style: FlutterFlowTheme.of(context).subtitle2,
                    ),
                  )),
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                    alignment: Alignment.bottomRight,
                    child: Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Details',
                        options: FFButtonOptions(
                          width: 60,
                          height: 40,
                          color: FlutterFlowTheme.of(context).primaryColor,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                              ),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: 10,
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ));
  }
}
