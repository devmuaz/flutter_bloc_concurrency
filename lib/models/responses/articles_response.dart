import 'package:equatable/equatable.dart';

import '../articles/article.dart';

class ArticlesResponse extends Equatable {
  final String? status;
  final int totalResults;
  final List<Article>? articles;

  const ArticlesResponse({
    this.status,
    this.totalResults = 0,
    this.articles,
  });

  factory ArticlesResponse.fromJson(Map<String, dynamic> map) {
    return ArticlesResponse(
      status: map['status'],
      totalResults: map['totalResults'],
      articles: map['articles'] != null
          ? List.from(map['articles'].map((x) => Article.fromMap(x)))
          : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, totalResults];
}
