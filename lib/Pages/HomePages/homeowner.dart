import 'dart:core';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homeapp/Pages/FunctionalityPages/addDevicePage.dart';
import 'package:homeapp/Pages/FunctionalityPages/addRoomWidget.dart';
import 'package:homeapp/Pages/FunctionalityPages/door_prediction_page.dart';
import 'package:homeapp/Pages/flutter_flow/homeAppWidgets.dart';
import 'package:homeapp/services/authentication.dart';
import 'package:homeapp/reusables/modelContainer.dart';
import 'package:homeapp/reusables/thermostatPage.dart';
import '../../widgets/climate_control_card.dart';

import '../../services/Animations.dart';
import '../ProfilePages/homeowner_profile.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:homeapp/model/Devices.dart';
import 'package:homeapp/reusables/device_card.dart';
import 'package:homeapp/reusables/doorContainer.dart';
import 'package:homeapp/model/roomModel.dart';
import 'package:intl/intl.dart';

class HomeownerHomePageWidget extends ConsumerStatefulWidget {
  const HomeownerHomePageWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeownerHomePageWidget> createState() =>
      _HomeownerHomePageWidgetState();
}

class _HomeownerHomePageWidgetState extends ConsumerState<HomeownerHomePageWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Authentication _authentication = Authentication();

  bool isRefreshing = false;
  bool isImageAvailable = false;
  bool _hasDevices = false;

  List<Room> _rooms = [];
  List<Device> _devicesList = [];
  String? date;
  String? greeting;
  DateTime now = DateTime.now();

  // Animation controllers for smooth transitions
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  Future<void> _initializeData() async {
    try {
      // Get user data
      final userData = await _authentication.getUserData();
      if (userData == null) return;

      // Get profile image and user name
      final imageUrl = await _authentication.getProfileImage();
      final userName = await _authentication.getUserName();

      // Get rooms and devices
      await Future.wait([
        _loadRooms(userData['uid']),
        _loadDevices(userData['uid']),
      ]);

      setState(() {
        isImageAvailable = imageUrl != null && imageUrl.isNotEmpty;
        date = DateFormat.yMMMMd('en_US').format(now);
        greeting = _getTimeBasedGreeting();
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  String _getTimeBasedGreeting() {
    int hour = now.hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<void> _loadRooms(String uid) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("rooms")
          .get();

      if (data.size > 0) {
        setState(() {
          _rooms = data.docs.map((doc) {
            return Room(
              name: doc['name'],
              color: HomeAppTheme.of(context).primaryColor,
            );
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching rooms: $e");
    }
  }

  Future<void> _loadDevices(String uid) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("devices")
          .orderBy('device name', descending: true)
          .get();

      setState(() {
        _devicesList =
            data.docs.map((doc) => Device.fromSnapshot(doc)).toList();
        _hasDevices = _devicesList.isNotEmpty;
      });
    } catch (e) {
      print("Error fetching devices: $e");
      _devicesList = [];
      _hasDevices = false;
    }
  }

  Future<void> refreshDevices() async {
    setState(() => isRefreshing = true);

    try {
      final userData = await _authentication.getUserData();
      if (userData != null) {
        await _loadDevices(userData['uid']);
      }
    } finally {
      setState(() => isRefreshing = false);
    }
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Profile Image with enhanced styling
          Hero(
            tag: 'profile_image',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeownerProfilePageWidget(),
                  ),
                ),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: HomeAppTheme.of(context).primaryColor,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: isImageAvailable
                          ? NetworkImage(_authentication.urlPath!.trim())
                          : const AssetImage('assets/images/iconapp.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Welcome Text with improved typography
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting ?? "Welcome",
                  style: HomeAppTheme.of(context).subtitle1.override(
                        fontFamily: 'Fira Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: HomeAppTheme.of(context).secondaryText,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _authentication.userName ?? "User",
                  style: HomeAppTheme.of(context).title2.override(
                        fontFamily: 'Fira Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: HomeAppTheme.of(context).primaryText,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        HomeAppTheme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    date ?? "",
                    style: HomeAppTheme.of(context).bodyText2.override(
                          fontFamily: 'Fira Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: HomeAppTheme.of(context).secondaryText,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: HomeAppTheme.of(context).subtitle1.override(
                  fontFamily: 'Fira Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: HomeAppTheme.of(context).primaryText,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DoorStatusContainer(
                  isDoorOpen: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoorPredictionPageWidget(),
                      ),
                    );
                  },
                  child: const PredictionContainer(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsSection() {
    if (_rooms.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rooms",
            style: HomeAppTheme.of(context).subtitle1.override(
                  fontFamily: 'Fira Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: HomeAppTheme.of(context).primaryText,
                ),
          ),
          const SizedBox(height: 12),
          RoomNamesWidget(rooms: _rooms),
        ],
      ),
    );
  }

  Widget _buildDevicesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Devices",
                style: HomeAppTheme.of(context).subtitle1.override(
                      fontFamily: 'Fira Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HomeAppTheme.of(context).primaryText,
                    ),
              ),
              if (_hasDevices)
                Text(
                  "${_devicesList.length} device${_devicesList.length != 1 ? 's' : ''}",
                  style: HomeAppTheme.of(context).bodyText2.override(
                        fontFamily: 'Fira Sans',
                        fontSize: 14,
                        color: HomeAppTheme.of(context).secondaryText,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_hasDevices)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: HomeAppTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: HomeAppTheme.of(context).alternate,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.device_phone_portrait,
                    size: 48,
                    color: HomeAppTheme.of(context).secondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No devices yet",
                    style: HomeAppTheme.of(context).subtitle2.override(
                          fontFamily: 'Fira Sans',
                          fontWeight: FontWeight.w600,
                          color: HomeAppTheme.of(context).secondaryText,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add your first smart device to get started",
                    textAlign: TextAlign.center,
                    style: HomeAppTheme.of(context).bodyText2.override(
                          fontFamily: 'Fira Sans',
                          color: HomeAppTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSpeedDial() {
    return SpeedDial(
      direction: SpeedDialDirection.up,
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: HomeAppTheme.of(context).primaryColor,
      foregroundColor: Colors.white,
      activeBackgroundColor: HomeAppTheme.of(context).secondaryBackground,
      activeForegroundColor: Colors.white,
      visible: true,
      closeManually: false,
      curve: Curves.easeOutCubic,
      //overlayColor: Colors.black,
      elevation: 8.0,
      onOpen: () => Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color:
                Colors.black.withValues(alpha: 0.2), // Semi-transparent overlay
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      childPadding: const EdgeInsets.symmetric(vertical: 8),
      spacing: 15,
      spaceBetweenChildren: 15,
      children: [
        SpeedDialChild(
          child: const Icon(CupertinoIcons.add_circled_solid),
          backgroundColor: HomeAppTheme.of(context).secondaryColor,
          foregroundColor: Colors.white,
          label: 'Add Smart Device',
          labelBackgroundColor: Colors.white,
          labelStyle: HomeAppTheme.of(context).subtitle2.override(
                fontFamily: 'Fira Sans',
                color: HomeAppTheme.of(context).secondaryText,
                fontWeight: FontWeight.w500,
              ),
          onTap: () => Navigator.push(
            context,
            Animations(
              page: const AddDevicePageWidget(),
              animationType: RouteAnimationType.slideFromBottom,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        SpeedDialChild(
          child: const Icon(CupertinoIcons.app),
          backgroundColor: HomeAppTheme.of(context).alternate,
          foregroundColor: Colors.white,
          label: 'Add Room',
          labelBackgroundColor: Colors.white,
          labelStyle: HomeAppTheme.of(context).subtitle2.override(
                fontFamily: 'Fira Sans',
                color: HomeAppTheme.of(context).secondaryText,
                fontWeight: FontWeight.w500,
              ),
          onTap: () => Navigator.push(
            context,
            Animations(
              page: const AddRoomPageWidget(),
              animationType: RouteAnimationType.slideFromBottom,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: HomeAppTheme.of(context).primaryBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: refreshDevices,
          color: HomeAppTheme.of(context).primaryColor,
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              // Enhanced App Bar
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: HomeAppTheme.of(context).primaryBackground,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 160,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          HomeAppTheme.of(context).primaryBackground,
                          HomeAppTheme.of(context)
                              .primaryBackground
                              .withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: _buildProfileSection(),
                    ),
                  ),
                ),
              ),

              // Quick Actions Section
              SliverToBoxAdapter(
                child: _buildQuickActionsSection(),
              ),

              // Rooms Section
              SliverToBoxAdapter(
                child: _buildRoomsSection(),
              ),

              // Climate Control Card
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ClimateControlCard(),
                ),
              ),

              SliverToBoxAdapter(child: _buildThermostatSection()),

              // Devices Section Header
              SliverToBoxAdapter(
                child: _buildDevicesSection(),
              ),

              // Devices Grid
              if (_hasDevices)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: _devicesList.length,
                      (BuildContext context, int index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          curve: Curves.easeOutCubic,
                          child: DeviceCard(_devicesList[index]),
                        );
                      },
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                  ),
                ),

              // Bottom padding for FAB
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 8),
        child: _buildEnhancedSpeedDial(),
      ),
    );
  }

  Widget _buildThermostatSection() {
    return const ThermostatWidget();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String getCurrentDate() {
    String formatter = DateFormat.yMMMMd('en_US').format(now);
    return formatter;
  }
}
