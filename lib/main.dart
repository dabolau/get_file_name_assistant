import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'home.dart';
import 'locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // 获取本地化标题逻辑
  final String languageCode =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final String localizedTitle =
      LocaleHelper.localizedValues['title']?[languageCode] ??
      LocaleHelper.localizedValues['title']!['en']!;

  WindowOptions windowOptions = WindowOptions(
    size: const Size(1024, 576),
    minimumSize: const Size(800, 450),
    center: true,
    title: localizedTitle,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitle(localizedTitle);
    await windowManager.show();
  });

  runApp(const GetFileNameAssistant());
}

class GetFileNameAssistant extends StatelessWidget {
  const GetFileNameAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => LocaleHelper.getText(context, 'title'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CH'), Locale('en', 'US')],
      // 核心修正：确保 tooltipTheme 在 ThemeData 内部
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),

        // 设置全局提示框主题
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFD0D0D0), width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(
            color: Color(0xFF383A42),
            fontSize: 18, // 统一大字号
            fontFamily: 'monospace',
          ),
          waitDuration: const Duration(milliseconds: 400),
        ),

        // 选中文本的色彩
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0xFFE5EBF7),
          selectionHandleColor: Color(0xFF526FFF),
        ),
      ),
      home: const HomePage(),
    );
  }
}
