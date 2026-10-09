import 'package:hive_flutter/adapters.dart';

import '../../features/news/data/models/article_model.dart';

class HiveService {
  static const String articlesBoxName = 'articles_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ArticleModelAdapter());

    await Hive.openBox<ArticleModel>(articlesBoxName);
  }
}
