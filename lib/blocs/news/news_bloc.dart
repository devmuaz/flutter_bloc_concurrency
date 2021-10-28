import 'dart:convert' show json;

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:http/http.dart' as http;

import '../../models/articles/article.dart';
import '../../models/responses/articles_response.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  static int _page = 1;
  static const _pageSize = 20;

  static final url = 'https://newsapi.org/v2/top-headlines?'
      'country=us&'
      'apiKey=ff957763c54c44d8b00e5e082bc76cb0&'
      'page=$_page&'
      'pageSize=$_pageSize';

  // any new articles will be appended to this list so we can use this list
  // to pass it to the ui.
  final List<Article> _articles = [];

  NewsBloc() : super(const NewsLoading()) {
    on<GetTopHeadlineArticles>((event, emit) async {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          final articlesResponse = ArticlesResponse.fromJson(body);

          if (articlesResponse.articles?.isNotEmpty ?? false) {
            _articles.addAll(articlesResponse.articles ?? const []);
          }

          // increasing the page number, so next time we get a different data
          // from the next page we requested.
          _page++;

          emit(NewsSuccess(
            articles: _articles,
            isMoreArticlesAvailableToLoad:
                articlesResponse.totalResults >= _pageSize,
          ));
        }
      } catch (e) {
        // could pass the type of cought error to the ui.
        emit(const NewsFailed());
      }
    }, transformer: droppable());
  }
}
