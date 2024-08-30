import 'package:flutter/material.dart';
 
void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/1',
      routes: {
        '/1':(context) => FirstPage(),
        '/2':(context) => SecondPage(),
        '/3':(context) => ThirdPage(),

      }  
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
 
 
 
  final String title;
 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
 
 
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
 
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NameCard(),
            // SizedBox(
            //   height: 200.0,
            //   child: Image.asset('assets/images/121.png',
            //   ),
            // ),
            // Image.network(
            //   'https://png.pngtree.com/png-clipart/20230511/ourmid/pngtree-isolated-cat-on-white-background-png-image_7094927.png'
            // ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Icon(Icons.remove),
                  onPressed:  _decrementCounter,
                ),
                ElevatedButton(
                  child: Icon(Icons.add),
                  onPressed: _incrementCounter,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 150.0,
            child: Image.asset('assets/images/121.png')
          ),
          Column(
            children:[
              Text('Name: Rawiwan Simmakum'),
              Text('DOB: 19 Dec 2001')
            ]
          )
          
        ]
      )
    );
  }
}

class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('First Page'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(3, (index){
          return InkWell(
            onTap: () {
              if (index == 0){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Page 1 is already here'))
                );
                return;
              }
              Navigator.pushNamed(context, '/${index+1}');
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home),
                  Text('Page ${index+1}'),
                ],
              ),
            ),
          );
        }
        
        ),
        ),
    );
  }
}
 
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
                  NameCard(),
                ],
              ),
            ),
);
        },
        
        ),
      
    );
  }
}
 
class ThirdPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Third Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/1');
            },
            icon: Icon(Icons.home)
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show message'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: const Text('Hello'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
 
                },
                ),
              ),
            );        
            },
        ),
      ),
    );
  }
}