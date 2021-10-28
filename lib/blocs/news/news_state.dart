part of 'news_bloc.dart';

abstract class NewsState {
  const NewsState();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsSuccess extends NewsState {
  final List<Article> articles;
  final bool isMoreArticlesAvailableToLoad;

  const NewsSuccess(
      {this.articles = const [], this.isMoreArticlesAvailableToLoad = true});
}

class NewsFailed extends NewsState {
  const NewsFailed();
}
