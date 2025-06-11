import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_provider.dart';

part 'navigation_provider.g.dart';

enum NavigationDestination {
  home,
  login,
  userMain,
}

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  NavigationDestination build() {
    return _determineDestination();
  }

  NavigationDestination _determineDestination() {
    final authState = ref.watch(authNotifierProvider);
    
    developer.log('Determining navigation destination', name: 'NavigationNotifier');
    developer.log('Auth state - isSignedIn: ${authState.isSignedIn}, user: ${authState.user?.uid}, userProfile: ${authState.userProfile}, isLoading: ${authState.isLoading}', 
        name: 'NavigationNotifier');

    // If auth is still loading, return home to avoid getting stuck
    if (authState.isLoading) {
      developer.log('Auth is loading, showing home screen', name: 'NavigationNotifier');
      return NavigationDestination.home;
    }

    // If not signed in, go to home (start page)
    if (!authState.isSignedIn || authState.user == null) {
      developer.log('User not signed in, navigating to home', name: 'NavigationNotifier');
      return NavigationDestination.home;
    }

    // If signed in, go to main user screen (regardless of profile completion)
    developer.log('User signed in, navigating to user main', name: 'NavigationNotifier');
    return NavigationDestination.userMain;
  }

  void refresh() {
    developer.log('Refreshing navigation destination', name: 'NavigationNotifier');
    state = _determineDestination();
  }
}

@riverpod
String navigationRoute(Ref ref) {
  final destination = ref.watch(navigationNotifierProvider);
  
  switch (destination) {
    case NavigationDestination.home:
      return '/homescreen';
    case NavigationDestination.login:
      return '/login';
    case NavigationDestination.userMain:
      return '/homeowner_main'; // Use the existing homeowner main as the single user main
  }
}

@riverpod
bool shouldShowLoading(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  
  // Only show loading if auth is actively loading (like during sign in)
  // But not during initial app startup
  return authState.isLoading && authState.user != null;
}