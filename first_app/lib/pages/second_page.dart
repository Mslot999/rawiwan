 
import 'package:first_app/components/name_card.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget{
  final List<String> entries = <String>['A', 'B', 'C','E','F','G'];
  final List<int> colorCodes = <int>[600, 500, 100, 600, 500, 100, 600];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Second Page'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8), 
        itemCount: entries.length,
        separatorBuilder: (context, index) {
          return Divider();
          },
        itemBuilder: (BuildContext context, int index) {
          return Container( 
            height: 250, 
            color: Colors.amber[colorCodes[index]], 
            child: Center(
              child: Column(
                children: [
                  Text('Item ${entries[index]}'),
                  NameCard(data: NameCardData(
                    name: 'Rawiwan Simmakum',
                    dob: 'xx/xx/xxxx',
                    imageUrl: 'https://mentor2code.com/assets/img/logo-small.png%27',
                    ),
                  )
                ],
              ),
            ),
);
        },
        
        ),
      
    );
  }
}
