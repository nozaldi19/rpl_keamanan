/// Model data untuk sebuah Post dari JSONPlaceholder.
class Post {
  /// ID pengguna pemilik post.
  final int userId;

  /// ID unik post.
  final int id;

  /// Judul post.
  final String title;

  /// Isi post.
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// Membuat [Post] dari JSON.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Mengubah [Post] menjadi JSON.
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}