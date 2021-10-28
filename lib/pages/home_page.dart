import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../blocs/news/news_bloc.dart';
import '../models/articles/article.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    useEffect(() {
      scrollController.addListener(() {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          BlocProvider.of<NewsBloc>(context)
              .add(const GetTopHeadlineArticles());
        }
      });
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bloc Concurrency Demo'),
      ),
      body: Center(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsSuccess) {
              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ArticleWidget(article: state.articles[index]),
                      childCount: state.articles.length,
                    ),
                  ),

                  // loading widget at the end of the scrolling items
                  // to indicates if there are more articles available
                  // to be loaded next request.
                  if (state.isMoreArticlesAvailableToLoad)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 32, top: 10),
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                ],
              );
            } else if (state is NewsFailed) {
              return const Text('Error Network Connection!');
            } else {
              return const CupertinoActivityIndicator();
            }
          },
        ),
      ),
    );
  }
}

class ArticleWidget extends HookWidget {
  final Article article;

  const ArticleWidget({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            article.title ?? 'title',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(article.description ?? 'description'),
          const Divider(),
        ],
      ),
    );
  }
}
