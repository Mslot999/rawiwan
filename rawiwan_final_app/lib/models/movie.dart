class Movie {
  final String id;
  final String title;
  final String genre;
  final int length;
  final int? eps;
  final String source;
  final String img;
  final String synopsis;
  final int release;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.length,
    this.eps,
    required this.source,
    required this.img,
    required this.synopsis,
    required this.release,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        title: json['title'],
        genre: json['genre'],
        length: json['length'],
        eps: json['eps'] ?? '',
        source: json['source'],
        img: json['img'],
        synopsis: json['synopsis'],
        release: json['release']);
  }
}
