import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/screen/news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsRepository newsModel = NewsRepository();
  final format = DateFormat("dd-MM-yyyy");
  final TextEditingController searchController = TextEditingController();

  Future<NewsModel>? currentNewsFuture;

  @override
  void initState() {
    super.initState();
    currentNewsFuture = newsModel.fetchNews();
  }

  Future<void> _refreshNews() async {
    setState(() {
      currentNewsFuture = newsModel.fetchNews();
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("News App", style: TextStyle(fontSize: w * 0.05)),
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                contentPadding: EdgeInsets.symmetric(
                  vertical: h * 0.01,
                  horizontal: w * 0.03,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w * 0.05),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  onPressed: () {
                    final query = searchController.text.trim();
                    setState(() {
                      currentNewsFuture = query.isNotEmpty
                          ? newsModel.searchNews(query)
                          : newsModel.fetchNews();
                    });
                  },
                  icon: Icon(Icons.search, size: w * 0.07),
                ),
              ),
            ),
            SizedBox(height: h * 0.02),
            Expanded(
              child: FutureBuilder<NewsModel>(
                future: currentNewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            CircularProgressIndicator(strokeWidth: w * 0.01));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(fontSize: w * 0.04),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final articles = snapshot.data!.articles ?? [];
                    return RefreshIndicator(
                      onRefresh: _refreshNews,
                      child: ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final date =
                              DateTime.parse(article.publishedAt ?? '');

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                    newsImage: article.urlToImage ??
                                        'https://via.placeholder.com/100',
                                    newsTitle: article.title ?? '',
                                    newsDescription: article.description ?? '',
                                    newsDate: article.publishedAt ?? '',
                                    newsAuthor: article.author ?? '',
                                    newsContent: article.content ?? '',
                                    newsSource: article.source?.name ?? '',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(w * 0.03),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(w * 0.02),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: w * 0.25,
                                      height: h * 0.12,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(w * 0.02),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            article.urlToImage ??
                                                'https://via.placeholder.com/100',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: w * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title ?? "No Title",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: h * 0.005),
                                          Text(
                                            article.source?.name ?? "Unknown",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: w * 0.04,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: h * 0.005),
                                          Text(
                                            format.format(date),
                                            style: TextStyle(
                                              fontSize: w * 0.035,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child:
                            CircularProgressIndicator(strokeWidth: w * 0.01));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
