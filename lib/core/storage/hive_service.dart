import 'package:hive_flutter/adapters.dart';

class HiveService {
  static const String articlesBoxName = 'articles_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Hive.registerAdapter(ArticleAdapter());

    await Hive.openBox(articlesBoxName);
  }
}
