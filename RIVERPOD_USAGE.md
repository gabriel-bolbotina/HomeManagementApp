# Riverpod State Management Usage Guide

This document explains how to use Riverpod state management in your Flutter home management app.

## Core Architecture

### 1. Authentication Provider (`lib/providers/auth_provider.dart`)

The authentication provider manages user authentication state globally.

#### Available Providers:
- `authNotifierProvider` - Main auth state (user, profile, loading, errors)
- `currentUserProvider` - Current Firebase user
- `currentUserProfileProvider` - Current user profile from Firestore
- `isSignedInProvider` - Boolean if user is signed in
- `isLoadingProvider` - Boolean if auth operation is in progress
- `authErrorProvider` - Current auth error message

#### Usage in Widgets:
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final authState = ref.watch(authNotifierProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    
    if (isLoading) {
      return CircularProgressIndicator();
    }
    
    if (authState.error != null) {
      return Text('Error: ${authState.error}');
    }
    
    return Text('Welcome ${userProfile?.firstName ?? 'User'}');
  }
}
```

#### Auth Actions:
```dart
// Sign in with email/password
await ref.read(authNotifierProvider.notifier).signInWithEmailAndPassword(
  email, 
  password
);

// Sign in with Google
await ref.read(authNotifierProvider.notifier).signInWithGoogle();

// Sign out
await ref.read(authNotifierProvider.notifier).signOut();

// Update user profile
await ref.read(authNotifierProvider.notifier).updateUserProfile(updatedUser);

// Clear errors
ref.read(authNotifierProvider.notifier).clearError();
```

### 2. Navigation Provider (`lib/providers/navigation_provider.dart`)

Handles automatic role-based navigation based on user state.

#### Available Providers:
- `navigationNotifierProvider` - Current navigation destination
- `navigationRouteProvider` - Route string for current destination
- `shouldShowLoadingProvider` - Whether to show loading screen

#### Usage:
```dart
class MyNavigationWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowLoading = ref.watch(shouldShowLoadingProvider);
    final navigationRoute = ref.watch(navigationRouteProvider);
    
    if (shouldShowLoading) {
      return LoadingScreen();
    }
    
    // Navigation happens automatically based on user state
    return getCurrentScreen(navigationRoute);
  }
}
```

## Converting Existing Widgets to Riverpod

### StatefulWidget → ConsumerStatefulWidget

**Before:**
```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**After:**
```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    // Now you have access to 'ref'
    final authState = ref.watch(authNotifierProvider);
    return Container();
  }
}
```

### StatelessWidget → ConsumerWidget

**Before:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**After:**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Now you have access to 'ref'
    final authState = ref.watch(authNotifierProvider);
    return Container();
  }
}
```

## Creating New Providers

### 1. Simple State Provider
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
}
```

### 2. Async Provider
```dart
@riverpod
class DeviceList extends _$DeviceList {
  @override
  Future<List<Device>> build() async {
    return await fetchDevicesFromFirestore();
  }
  
  Future<void> addDevice(Device device) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await saveDeviceToFirestore(device);
      return await fetchDevicesFromFirestore();
    });
  }
}
```

### 3. Family Provider (with parameters)
```dart
@riverpod
class RoomDevices extends _$RoomDevices {
  @override
  Future<List<Device>> build(String roomId) async {
    return await fetchDevicesForRoom(roomId);
  }
}

// Usage:
final devices = ref.watch(roomDevicesProvider('living-room'));
```

## Best Practices

### 1. Provider Naming
- Use descriptive names: `authNotifierProvider`, `deviceListProvider`
- End with "Provider": `userProfileProvider`
- Use camelCase: `homeDevicesProvider`

### 2. State Management
- Keep providers focused on single responsibility
- Use `.notifier` for actions: `ref.read(counterProvider.notifier).increment()`
- Use `ref.watch()` for reactive updates
- Use `ref.read()` for one-time reads (like in event handlers)

### 3. Error Handling
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final asyncValue = ref.watch(deviceListProvider);
  
  return asyncValue.when(
    data: (devices) => DeviceList(devices: devices),
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => ErrorWidget(error: error.toString()),
  );
}
```

### 4. Performance
- Use `ref.watch()` only for data you need to react to
- Use `ref.listen()` for side effects (navigation, showing dialogs)
- Consider using `select()` to watch only specific parts of state

```dart
// Watch only the loading state, not the entire auth state
final isLoading = ref.watch(authNotifierProvider.select((state) => state.isLoading));
```

## Migration Strategy

1. **Start with new features** - Use Riverpod for any new widgets/features
2. **Convert critical paths** - Convert login, authentication flows first
3. **Gradual migration** - Convert existing widgets one by one
4. **Remove old state management** - Phase out setState, InheritedWidget, etc.

## Testing with Riverpod

```dart
void main() {
  testWidgets('Login widget test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Mock the auth provider for testing
          authNotifierProvider.overrideWith(() => MockAuthNotifier()),
        ],
        child: LoginPageWidget(),
      ),
    );
    
    // Test your widget...
  });
}
```

## Common Patterns

### 1. Listening for Navigation
```dart
ref.listen(authNotifierProvider, (previous, next) {
  if (next.isSignedIn && previous?.isSignedIn == false) {
    // Navigate to home screen
    Navigator.pushReplacementNamed(context, '/home');
  }
});
```

### 2. Form Validation
```dart
@riverpod
class LoginForm extends _$LoginForm {
  @override
  Map<String, String?> build() => {
    'email': null,
    'password': null,
  };
  
  void updateEmail(String email) {
    state = {...state, 'email': email};
  }
  
  void updatePassword(String password) {
    state = {...state, 'password': password};
  }
  
  bool get isValid => 
    state['email']?.isNotEmpty == true && 
    state['password']?.isNotEmpty == true;
}
```

### 3. Combining Multiple Providers
```dart
@riverpod
Future<UserDashboard> userDashboard(Ref ref) async {
  final user = await ref.watch(currentUserProfileProvider.future);
  final devices = await ref.watch(userDevicesProvider.future);
  final rooms = await ref.watch(userRoomsProvider.future);
  
  return UserDashboard(
    user: user,
    devices: devices,
    rooms: rooms,
  );
}
```

This Riverpod implementation provides a solid foundation for scalable state management in your Flutter app!