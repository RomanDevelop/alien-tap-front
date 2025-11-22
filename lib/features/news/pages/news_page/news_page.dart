import 'package:flutter/material.dart' hide WidgetState;
import 'package:mwwm/mwwm.dart';
import 'package:alien_tap/app/theme/neon_theme.dart';
import 'news_wm.dart';
import 'di/news_wm_builder.dart';

class NewsPage extends CoreMwwmWidget<NewsWidgetModel> {
  NewsPage({Key? key}) : super(key: key, widgetModelBuilder: (ctx) => createNewsWidgetModel(ctx));
  @override
  WidgetState<NewsPage, NewsWidgetModel> createWidgetState() => _NewsPageState();
}

class _NewsPageState extends WidgetState<NewsPage, NewsWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: NeonTheme.backgroundGradient,
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: wm.newsStream,
                initialData: [],
                builder: (ctx, snap) {
                  final news = snap.data ?? [];
                  if (news.isEmpty) {
                    return Center(child: Text('Нет новостей', style: TextStyle(color: NeonTheme.mediumText)));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: news.length,
                    itemBuilder:
                        (ctx, i) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: NeonTheme.cardGradient,
                          child: Text('Новость ${i + 1}', style: TextStyle(color: NeonTheme.lightText)),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [NeonTheme.darkSurface, NeonTheme.darkCard],
        ),
      ),
      child: AppBar(
        title: Text(
          wm.i18n.pageTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(shadows: NeonTheme.neonTextShadow),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: NeonTheme.brandBrightGreen), onPressed: wm.goBack),
      ),
    );
  }
}
