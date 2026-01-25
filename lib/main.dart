import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart' as intl;
import 'package:qqai/router/app_router.dart';

import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'util/my_shared_pref.dart';
import 'providers/app_config_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init shared preference
  await MySharedPref.init();
  intl.initializeDateFormatting().then((_) => runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeIsLight = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    // 使用 read 而不是 watch，避免 GoRouter 频繁重建
    final router = ref.read(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(1170, 2532),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, child) {
        return MaterialApp.router(
          title: '千千Ai',
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales:
              LocalizationService.supportedLanguages.values.toSet().toList(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: MyTheme.getThemeData(isLight: true),
          darkTheme: MyTheme.getThemeData(isLight: false),
          themeMode: themeIsLight ? ThemeMode.light : ThemeMode.dark,
          routerConfig: router,
          builder: (context, widget) {
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: widget!,
              ),
            );
          },
        );
      },
    );
  }
}
