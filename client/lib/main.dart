import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/pages/splash_screen.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initSharedPreferences();
  await container.read(authViewmodelProvider.notifier).getData();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final container = ProviderContainer();
//   final notifier = container.read(authViewmodelProvider.notifier);
//   await notifier.initSharedPreferences();
//   final userModel = await notifier.getData();
//   print(userModel);
//   runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
// }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Melodify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home:
          currentUser == null
              ? const SplashScreen()
              : const Scaffold(
                body: Center(
                  child: Text(
                    'Welcome to Melodify!',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
    );
  }
}
