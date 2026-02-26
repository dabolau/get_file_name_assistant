import 'package:flutter/material.dart';

class LocaleHelper {
  // 确保是 static 且公开，方便 main.dart 启动时读取标题
  static final Map<String, Map<String, String>> localizedValues = {
    'title': {'zh': '获取文件名助手', 'en': 'Get File Name Assistant'},
    'open': {'zh': '打开文件夹', 'en': 'Open Folder'},
    'copy': {'zh': '一键复制', 'en': 'Copy All'},
    'clear': {'zh': '一键清空', 'en': 'Clear All'},
    'web': {'zh': '官方网站', 'en': 'Official Website'},
    'hint': {'zh': '拖放文件夹到这里', 'en': 'Drop folder here'},
    'success': {'zh': '成功获取文件名', 'en': 'Success!'},
    'copied': {'zh': '内容已复制到剪贴板', 'en': 'Copied to clipboard'},
    'cleared': {'zh': '内容已清空', 'en': 'Cleared'},
    'errorNotFolder': {'zh': '这好像不是文件夹', 'en': 'That is not a folder'},
  };

  static String getText(BuildContext context, String key) {
    String code = Localizations.localeOf(context).languageCode;
    // 逻辑：如果对应语言不存在则回退到英文
    return localizedValues[key]?[code] ?? localizedValues[key]?['en'] ?? '';
  }
}
