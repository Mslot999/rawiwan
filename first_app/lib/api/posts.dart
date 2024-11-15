import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
 
 
class Post {
  String id;
  String title;
  int views;
  bool isRead;
  String dbId = "";
 
  Post(this.id, this.title, this.views, this.isRead);
 
  factory Post.fromSnapshot(Map<String, dynamic> json) {
    return Post(
      json['postId'] as String,
      json['title'] as String,
      json['views'] as int? ?? 0,
      json['isRead'] as bool? ?? false,
    );
  }
 
 
  factory Post.fromJson(Map json) {
    return Post(
      json['id'] as String,
      json['title'] as String,
      json['views'] as int? ?? 0,
      json['isRead'] as bool? ?? false,
    );
  }
}
 
class AllPosts {
  final List<Post> posts;
  AllPosts(this.posts);
 
  factory AllPosts.fromSnapshot(QuerySnapshot qs) {
    List<Post> posts;
 
    posts = qs.docs.map((DocumentSnapshot ds) {
      Post post = Post.fromSnapshot(ds.data() as Map<String, dynamic>);
      post.dbId = ds.id;
      return post;
    }).toList();
 
    return AllPosts(posts);
  }
 
 
 
 
  factory AllPosts.fromJson(List json) {
    List<Post> posts;
    posts = json.map((item) => Post.fromJson(item)).toList();
    return AllPosts(posts);
  }
}
 
abstract class PostService {
  Future<List<Post>> getPosts();
  void updatePost(Post post);
  Future<Post> addPost(Post post);
}
 
class PostFirebaseService implements PostService {
  @override
  Future<List<Post>> getPosts()  async {
    QuerySnapshot qs =
      await FirebaseFirestore.instance.collection('posts').get();
    AllPosts all = AllPosts.fromSnapshot(qs);
    return all.posts;
  }
 
  @override
  Future<Post> addPost(Post post) {
    throw UnimplementedError();
  }
 
  @override  
  void updatePost(Post post) {
 
  }
}
 
class PostController {
  List<Post> posts = List.empty();
  final PostService service;
 
  StreamController<bool> onSyncController = StreamController();
  Stream<bool> get onSync => onSyncController.stream;
 
  PostController(this.service);
 
  Future<List<Post>> fetchPosts() async {
    onSyncController.add(true);
    posts = await service.getPosts();
    onSyncController.add(false);
    return posts;
  }
}