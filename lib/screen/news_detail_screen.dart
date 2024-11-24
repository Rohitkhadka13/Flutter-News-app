import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String? newsImage;
  final String newsTitle;
  final String newsDescription;
  final String newsDate;
  final String newsAuthor;
  final String newsContent;
  final String newsSource;

  const NewsDetailScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDescription,
    required this.newsDate,
    required this.newsAuthor,
    required this.newsContent,
    required this.newsSource,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

final format = DateFormat("dd-MM-yyyy");

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
   
    DateTime dateTime = DateTime.parse(widget.newsDate);
    String fullContent =
        widget.newsContent.replaceAll(RegExp(r"\[\+\d+ chars\]"), '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: h * 0.45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newsImage?? "https://via.placeholder.com/100",
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Container(
            height: h * .6,
            margin: EdgeInsets.only(top: h * 0.4),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  widget.newsTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.newsSource,
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Text(
                  widget.newsDescription,
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Text(
                  fullContent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
