import 'package:fife_image/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin FifeImageRouter {
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        name: MainScreen.route,
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const MainScreen(),
      ),
    ],
  );
}
