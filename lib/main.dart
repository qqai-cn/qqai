import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart' as intl;
import 'package:qqai/router/app_router.dart';

import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'util/my_shared_pref.dart';
import 'util/api_base_client.dart';
import 'providers/auth_providers.dart';
import 'providers/app_config_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 禁止 google_fonts 运行时从 fonts.gstatic.com 拉取字体（避免 Roboto 等请求）
  // GoogleFonts.config.allowRuntimeFetching = false;
  // init shared preference
  await MySharedPref.init();
  intl.initializeDateFormatting().then((_) => runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // 在 initState 后通过 addPostFrameCallback 安全地设置回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ApiBaseClient.setRefreshCallbacks(
          onRefreshToken: () => ref.read(authProvider.notifier).refreshToken(),
          onLogout: () => ref.read(authProvider.notifier).logout(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeIsLight = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    // watch：登录态变化或路由表更新后使用新的 GoRouter，避免一直用首次创建的实例
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      // 须为设计稿「逻辑宽」≈ 375～430，勿填物理像素宽（如 1170≈390×3），
      // 否则 .sp 会按 screenWidth/designWidth 缩小，小屏上 18.sp 会变成几 dp 看不清。
      // 同一 designSize 在 iOS/Android/Web 均生效；字号 clamp 见 util/adaptive_sp.dart。
      designSize: const Size(390, 844),
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
