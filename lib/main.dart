import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pdf_scanner/src/common/app_loader_overlay.dart';
import 'package:pdf_scanner/src/core/router/app_router.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('it'),
        Locale('pt', 'BR'),
        Locale('es'),
        Locale('fr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        observers: [TalkerRiverpodObserver()],
        child: DevicePreview(
          enabled: false,
          builder:
              (context) => GlobalLoaderOverlay(
                useDefaultLoading: false,
                overlayWidgetBuilder: (_) => const AppLoaderOverlay(),
                child: const MyApp(),
              ),
        ),
      ),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'PDF Scanner',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
