import 'package:flutter/material.dart';
import 'package:riverdrift/features/news/data/models/news_model.dart';

class NewsTile extends StatelessWidget {
  final News news;
  const NewsTile({super.key, required this.news});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Image.network(
                  news.urlToImage,
                  scale: 1,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                    );
                  },
                ),
                ListTile(
                  title: Text(news.title),
                  subtitle: Text(news.description),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
