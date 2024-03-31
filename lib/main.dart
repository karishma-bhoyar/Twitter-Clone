import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/common/error_page.dart';
import 'package:flutter_twitter_clone/common/loading_page.dart';
import 'package:flutter_twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/features/home/view/home_view.dart';
import 'package:flutter_twitter_clone/features/view/signup_view.dart';
import 'package:flutter_twitter_clone/theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAcount = ref.watch(currentUserAccountProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitter Clone App',
      theme: AppTheme.theme,
      home: currentAcount.when(
          data: (user) {
            if (user != null) {
              return const HomeView();
            }
            return const SignUpView();
          },
          error: (error, st) {
            return ErrorPage(error: error.toString());
          },
          loading: () => const LoadingPage()),
    );
  }
}
