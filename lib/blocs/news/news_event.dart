part of 'news_bloc.dart';

abstract class NewsEvent {
  const NewsEvent();
}

class GetTopHeadlineArticles extends NewsEvent {
  const GetTopHeadlineArticles();
}
