import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Devices.dart';

class RoomDetailsPage extends StatelessWidget {
  //final Device device;
  final String name;
  final Color color;

  RoomDetailsPage(
      {required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: Hero(
              tag: 'roomName$name',
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: color,
                    )
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      name,
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
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(
                'Device Details',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
