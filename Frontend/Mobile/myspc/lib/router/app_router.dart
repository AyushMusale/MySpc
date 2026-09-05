import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../injection.dart';
import '../presentation/auth/bloc/signup_bloc.dart';
import '../presentation/auth/pages/signup/signup_page.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.signupRoute,
  routes: [
    GoRoute(
      path: AppConstants.signupRoute,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<SignupBloc>(),
        child: const SignupPage(),
      ),
    ),
    GoRoute(
      path: AppConstants.loginRoute,
      builder: (context, state) => const _LoginStubPage(),
    ),
    GoRoute(
      path: AppConstants.homeRoute,
      builder: (context, state) => const _HomeStubPage(),
    ),
  ],
);

/// Placeholder until LoginPage is built
class _LoginStubPage extends StatelessWidget {
  const _LoginStubPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: TextButton(
          onPressed: () => context.go(AppConstants.signupRoute),
          child: const Text('Go to Signup'),
        ),
      ),
    );
  }
}

/// Placeholder until HomeScreen is built
class _HomeStubPage extends StatelessWidget {
  const _HomeStubPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('🎉 Welcome to MySpc!')),
    );
  }
}
