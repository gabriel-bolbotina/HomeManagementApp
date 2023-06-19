import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Pages/flutter_flow/HomeAppTheme.dart';
import '../Pages/flutter_flow/homeAppWidgets.dart';
import '../model/Devices.dart';

import 'devicePage.dart';

class DeviceCard extends StatelessWidget {
  final Device _device;

  const DeviceCard(this._device, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Hero(
      tag: 'deviceImage$_device.deviceName',
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DeviceDetailPage(deviceName: _device.deviceName!, imageUrl: _device.uploadedImage ?? "" , serialNumber: _device.serialNumber!, type: _device.type, brand: _device.brand, timestamp: _device.timestamp,))),

        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
            child: Container(
              //padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              width: MediaQuery.of(context).size.width * 0.45,
              height: 190,
              decoration: BoxDecoration(
                color: HomeAppTheme.of(context).primaryColor.withOpacity(0.25),
                // boxShadow: const [
                //BoxShadow(
                //blurRadius: 4,
                //color: Color(0xFF8E97B9),
                //offset: Offset(0, 2),
                //)
                //],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                child: Stack(
                    alignment: AlignmentDirectional.topStart,
                    textDirection: TextDirection.ltr,
                    children: [

                        ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:  CachedNetworkImage(
                                imageUrl: _device.uploadedImage!,
                                width: double.infinity,
                                height: 115,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                    child: CupertinoActivityIndicator(
                                  color: HomeAppTheme.of(context).primaryColor,
                                )), // Placeholder widget while loading
                                errorWidget: (context, url, error) => const Icon(Icons
                                    .error), // Error widget when the image fails to load
                              ))
                        ,


                      BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 30)),
                      Container(
                          alignment: Alignment.bottomLeft,
                          constraints: const BoxConstraints.tightFor(
                              width: 100, height: 400),
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                            child: Text(
                              _device.deviceName!,
                              style: HomeAppTheme.of(context).subtitle2,
                            ),
                          )),
                      Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 0, 8),
                        alignment: Alignment.bottomRight,
                        child: Expanded(
                          child: HomeAppButtonWidget(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeviceDetailPage(deviceName: _device.deviceName!, imageUrl: _device.uploadedImage ?? "" ))),
                            text: 'Details',
                            options: HomeAppButtonOptions(
                              width: 60,
                              height: 40,
                              color: HomeAppTheme.of(context).primaryColor,
                              textStyle: HomeAppTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Poppins',
                                    color:
                                        HomeAppTheme.of(context).secondaryText,
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
            )),
      ),
    );
  }
}
