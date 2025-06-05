import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'providers/navigation_provider.dart';

class DebugAuthWidget extends ConsumerWidget {
  const DebugAuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final navigationDestination = ref.watch(navigationNotifierProvider);
    final navigationRoute = ref.watch(navigationRouteProvider);
    final shouldShowLoading = ref.watch(shouldShowLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Auth State'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Auth State:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Is Signed In: ${authState.isSignedIn}'),
                    Text('Is Loading: ${authState.isLoading}'),
                    Text('User ID: ${authState.user?.uid ?? "null"}'),
                    Text('User Email: ${authState.user?.email ?? "null"}'),
                    Text('Error: ${authState.error ?? "none"}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Profile:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('First Name: ${authState.userProfile?.firstName ?? "null"}'),
                    Text('Last Name: ${authState.userProfile?.lastName ?? "null"}'),
                    Text('Address: "${authState.userProfile?.address ?? "null"}"'),
                    Text('Has Address: ${authState.userProfile?.hasAddress ?? false}'),
                    Text('Profile Complete: ${authState.userProfile?.isProfileComplete ?? false}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Navigation:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Destination: $navigationDestination'),
                    Text('Route: $navigationRoute'),
                    Text('Should Show Loading: $shouldShowLoading'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
              },
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.read(navigationNotifierProvider.notifier).refresh();
              },
              child: const Text('Refresh Navigation'),
            ),
          ],
        ),
      ),
    );
  }
}