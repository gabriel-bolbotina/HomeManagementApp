import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Pages/flutter_flow/HomeAppTheme.dart';
import '../model/Devices.dart';

class DeviceDetailPage extends StatelessWidget {
  //final Device device;
  final String deviceName;
  final String imageUrl;
  final int? serialNumber;
  final String? type;
  final String? brand;
  final Timestamp? timestamp;

  const DeviceDetailPage(
      {super.key, required this.deviceName,
      required this.imageUrl,
      this.serialNumber,
      this.type,
      this.brand,
      this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: 'deviceImage$deviceName',
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    deviceName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              )),
          SliverToBoxAdapter(
              child: SizedBox(
                  height: 20,
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                        child: RichText(
                          overflow: TextOverflow.visible,
                          text: const TextSpan(
                            text: "Device info",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      )))),
          SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
                child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: HomeAppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: deviceName,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: HomeAppTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                    ))),
          ),
      SliverToBoxAdapter(
        child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
              child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: HomeAppTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "$serialNumber",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: HomeAppTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  )))),
      SliverToBoxAdapter(
        child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
              child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: HomeAppTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: brand ?? "",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: HomeAppTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  )))),

      SliverToBoxAdapter(
        child:Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 14, 24, 0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: HomeAppTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: type ?? "",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: HomeAppTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  )))),
        ],
      ),
    );
  }
}
