import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverdrift/features/news/presentation/widgets/news_tile.dart';
import 'package:riverdrift/features/todo/data/database/database.dart';
import '../../data/models/news_model.dart';

final dataStreamProvider = StreamProvider<List<News>>((ref) async* {
  final database = ref.read(databaseProvider);
  final newsFromDb = await database.getallNews();
  final convertedNews = newsFromDb
      .map((newsTableData) => News(
            title: newsTableData.title,
            description: newsTableData.description,
            url: newsTableData.url,
            urlToImage: newsTableData.urlToImage,
          ))
      .toList();
  yield convertedNews;

  while (true) {
    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=in&apiKey=82ff511e0a334886a8c4afd326335dc2'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final news = (jsonData['articles'] as List<dynamic>)
            .map((articleJson) => News.fromJson(articleJson))
            .toList();

        for (final newsItem in news) {
          await database.insertNews(News(
            title: newsItem.title,
            description: newsItem.description,
            url: newsItem.url,
            urlToImage: newsItem.urlToImage,
          ));
        }

        yield news;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        print('Socket Exception: $e');
      } else {
        print('Other Exception: $e');
      }
    }
    // Delay before fetching data again
    await Future.delayed(Duration(minutes: 5));
  }
});

// NewsPage widget
class NewsPage extends ConsumerWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsyncValue = ref.watch(dataStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('News Page'),
      ),
      body: SafeArea(
        child: Center(
          child: dataAsyncValue.when(
            data: (data) {
              if (data.isEmpty) {
                return Text('No data available');
              } else {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final newsData = data[index];
                    return NewsTile(news: newsData);
                  },
                );
              }
            },
            loading: () {
              return CircularProgressIndicator();
            },
            error: (error, stackTrace) {
              return Text('Error: $error');
            },
          ),
        ),
      ),
    );
  }
}
