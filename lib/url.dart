import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  // 打开官方网站链接
  static Future<void> openWebsite() async {
    final Uri url = Uri.parse('https://your-website.com');
    if (!await launchUrl(url)) {
      debugPrint('Could not launch the website');
    }
  }
}
