import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
 
class SeventhPage extends StatefulWidget {

  @override
  State<SeventhPage> createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  List<Post> posts = List.empty();
  bool isLoading = false;
  PostController controller = PostController(PostHttpService());

  @override
  void initState() {
    super.initState();

    controller.onSync.listen((bool syncState) {
      setState(() {
        isLoading = syncState;
      });
    });
  }

  void _getPosts() async{
    var newPosts = await controller.fetchPosts();
    setState(() {
      posts = newPosts;
    });
  }

  Widget get body => isLoading
  ? CircularProgressIndicator()
  : ListView.builder(
    itemCount: posts.isNotEmpty? posts.length : 1,
    itemBuilder: (context, index) {
      if (posts.isNotEmpty){
        return CheckboxListTile(
          title: Text(posts[index].title),
          value: posts[index].isRead, 
          onChanged: (value){
            setState(() => posts[index].isRead = value!);
          });

      }
      return Center(
        child: Text("Yeah Tap btn to feych posts"),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Posts'),
      ),
      body: Center(
        child: body,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getPosts,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Post{
  String id;
  final String title;
  int views;
  bool isRead;

  Post(this.id, this.title, this.views, this.isRead);
  factory Post.fromJson(Map json) {
    return Post(
      json['id'] as String, 
      json['title'] as String, 
      json['views'] as int? ?? 0, 
      json['isRead'] as bool? ?? false, ); 
  } 
} 

class AllPosts { 
  final List<Post> posts; 
  
  AllPosts(this.posts); 

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

class PostHttpService implements PostService{
  Client client = Client();
  @override
  Future<Post> addPost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() async {
    final response = await client.get(
      Uri.parse('http://172.25.27.6:3000/posts'),
      );
      await Future.delayed(
        Duration(seconds:2 )
      );
      if (response.statusCode == 200) {
        var all = AllPosts.fromJson(json.decode(response.body));
        return all.posts;
      }
      throw Exception('Fail to load posts');
        
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

  Future<List<Post>> fetchPosts() async{
    onSyncController.add(true);
    posts = await service.getPosts();
    onSyncController.add(false);
    return posts;
  }
}