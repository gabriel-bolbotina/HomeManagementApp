import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path/path.dart' as path;

import '../reusables/thermostatPage.dart';
import '../Pages/flutter_flow/HomeAppTheme.dart';
import '../Pages/flutter_flow/homeAppWidgets.dart';

class RoomDetailsPage extends StatefulWidget {
  final String name;
  final Color color;

  const RoomDetailsPage({Key? key, required this.name, required this.color}) : super(key: key);

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  File? _photo;
  String? _currentImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRoomImage();
  }

  Future<void> _loadRoomImage() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('rooms')
            .doc(widget.name)
            .get();
        
        if (doc.exists && doc.data()?['uploadedImage'] != null) {
          setState(() {
            _currentImageUrl = doc.data()!['uploadedImage'];
          });
        }
      }
    } catch (e) {
      // print('Error loading room image: $e');
    }
  }

  Future<void> _deleteRoom() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Room'),
        content: Text('Are you sure you want to delete ${widget.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('rooms')
              .doc(widget.name)
              .delete();
          
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.name} deleted successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting room: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeRoomPicture() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_photo == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final fileName = path.basename(_photo!.path);
        final destination = 'rooms/${user.uid}/${widget.name}/$fileName';

        final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
        final uploadTask = await ref.putFile(_photo!);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('rooms')
            .doc(widget.name)
            .update({'uploadedImage': downloadUrl});

        setState(() {
          _currentImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room picture updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeAppTheme.of(context).primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            backgroundColor: HomeAppTheme.of(context).primaryBackground,
            flexibleSpace: Hero(
              tag: 'roomName${widget.name}',
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _currentImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: _currentImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: widget.color,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: widget.color,
                            ),
                          )
                        : Container(
                            color: widget.color,
                          ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 100,
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _changeRoomPicture,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: _deleteRoom,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Climate Control',
                    style: HomeAppTheme.of(context).subtitle1.override(
                      fontFamily: 'Fira Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: HomeAppTheme.of(context).primaryText,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: HomeAppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: HomeAppTheme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.thermostat,
                                color: HomeAppTheme.of(context).primaryColor,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                '${widget.name} Thermostat',
                                style: HomeAppTheme.of(context).subtitle2.override(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: HomeAppTheme.of(context).primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ThermostatWidget(roomName: widget.name),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Room Devices',
                    style: HomeAppTheme.of(context).subtitle1.override(
                      fontFamily: 'Fira Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: HomeAppTheme.of(context).primaryText,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: HomeAppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.devices_other,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No devices connected',
                            style: HomeAppTheme.of(context).bodyText2.override(
                              fontFamily: 'Poppins',
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add devices to control them from here',
                            style: HomeAppTheme.of(context).bodyText2.override(
                              fontFamily: 'Poppins',
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          HomeAppButtonWidget(
                            onPressed: () {
                              // Navigate to add device page
                            },
                            text: 'Add Device',
                            options: HomeAppButtonOptions(
                              width: 150,
                              height: 40,
                              color: HomeAppTheme.of(context).primaryColor,
                              textStyle: HomeAppTheme.of(context).bodyText2.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              elevation: 2,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
