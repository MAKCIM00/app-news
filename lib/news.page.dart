import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> future;

  @override
  void initState() {
    future = getNewsData();
    super.initState();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI("51fb2dcf7faa40fa94ce1b48a2f8ae03");
    return await newsAPI.getTopHeadlines(
      country: "us",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading the news"),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return _buildNewsListView(snapshot.data as List<Article>);
                  } else {
                    return const Center(
                      child: Text("No news available"),
                    );
                  }
                }
              },
              future: future,
            ),
          )
        ],
      )),
    );
  }
}

Widget _buildNewsListView(List<Article> articleList) {
  return ListView.builder(
    itemBuilder: (context, index) {
      Article article = articleList[index];
      return Text(article.title!);
    },
    itemCount: articleList.length,
  );
}
