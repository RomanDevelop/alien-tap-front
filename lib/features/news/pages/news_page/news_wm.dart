import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'news_i18n.dart';
import 'navigation/news_navigator.dart';
import '../../repositories/news_repository.dart';

class NewsWidgetModel extends WidgetModel {
  final NewsRepository _repository;
  final NewsNavigator _navigator;
  final NewsI18n i18n;
  final Logger _logger = Logger();
  final BehaviorSubject<List<Map<String, dynamic>>> _news = BehaviorSubject.seeded([]);
  Stream<List<Map<String, dynamic>>> get newsStream => _news.stream;
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoadingStream => _isLoading.stream;
  NewsWidgetModel(this._repository, this._navigator, this.i18n, WidgetModelDependencies dependencies)
    : super(dependencies);
  @override
  void onLoad() {
    super.onLoad();
    _loadNews();
  }

  @override
  void dispose() {
    _news.close();
    _isLoading.close();
    super.dispose();
  }

  Future<void> _loadNews() async {
    _isLoading.add(true);
    try {
      final news = await _repository.getData();
      _news.add(news);
    } catch (e) {
      _logger.e('Failed to load news', error: e);
    } finally {
      _isLoading.add(false);
    }
  }

  void goBack() => _navigator.goBack();
}
