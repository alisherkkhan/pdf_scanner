import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/src/features/app/screen/app_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/app',
    routes: routeList,
  );
});

List<GoRoute> routeList = [
  GoRoute(
    path: '/app',
    name: 'app',
    builder: (context, state) => const AppScreen(),
  ),
];
