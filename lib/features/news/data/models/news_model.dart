
// Define News model class
class News {
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
    };
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}