import 'package:first_app/api/posts.dart';
import 'package:flutter/material.dart';
 
 
class SeventhPage extends StatefulWidget {
  @override
  State<SeventhPage> createState() => _SeventhPageState();
}
 
class _SeventhPageState extends State<SeventhPage> {
  List<Post> posts = List.empty();
  bool isLoading = false;
  PostController controller = PostController(PostFirebaseService());
 
  @override
  void initState() {
    super.initState();
 
    controller.onSync.listen((bool syncState) {
      setState(() {
        isLoading = syncState;
      });
    });
  }
 
  void _getPosts() async {
    var newPosts = await controller.fetchPosts();
    setState(() {
      posts = newPosts;
    });
  }
 
  Widget get body => isLoading
      ? CircularProgressIndicator()
      : ListView.builder(
          itemCount: posts.isNotEmpty ? posts.length : 1,
          itemBuilder: (context, index) {
            if (posts.isNotEmpty) {
              return CheckboxListTile(
                  title: Text(posts[index].title),
                  value: posts[index].isRead,
                  onChanged: (value) {
                    setState(() => posts[index].isRead = value!);
                    controller.updatePost(posts[index]);
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
 