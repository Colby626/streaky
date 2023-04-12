import 'package:flutter/material.dart';
import 'package:streaky/Streak.dart';
import 'StreakButton.dart';
import 'StreakData.dart' as streakData;
/*
Map<String, dynamic> conversationMap = {
  "conversations" : [
    String, dynamic> {
      "conversationID" : "1234",
      "title" : "Haily",
      "lastMessage" : "I love you!",
      "timestamp" : 123456789
    },
    <String, dynamic> {
      "conversationID" : "4321",
      "title" : "Mom",
      "lastMessage" : "Love y'all",
      "timestamp" : 987654321
    },<
  ]
};
*/

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final number = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Streaky",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Streaky"),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Row(
              children: [
                IconButton(
                    color: Colors.white,
                    tooltip: "Calendar",
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () {} //calendar goes here,
                ),
                IconButton(
                  color: Colors.white,
                  tooltip: "Settings",
                  icon: const Icon(Icons.settings),
                  onPressed: () {}, //settings goes here
                )
              ],
            ),
          ),
          body: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreakButton("New Streak", number),
                      ValueListenableBuilder<int>(
                        valueListenable: number,
                        builder: (BuildContext context, int value,
                            Widget? child) {
                          return Column(
                            children: [
                              for (int i = 0; i <
                                  streakData.streaks.length; i++)
                                Streak(streakData.streaks[i].name, streakData
                                    .streaks[i].streakCount, Icons
                                    .access_time_filled)
                            ],
                          );
                        },
                      ),
                    ],
                  )
              )
          ),
        )
    );
  }
}
/*
  @override
  Widget build (BuildContext context){
    return MaterialApp(
        title: 'Streaky',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
                title: const Text("Streaky")
            ),
            body: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Streak Widget
                        const ConversationButton("123", "title", "lastMessage"),
                        //Add new streak button
                        const Padding(
                          padding: EdgeInsets.all(5)
                        ),
                        ElevatedButton(
                            child: const Text("Add new streak"),
                            onPressed: (){} //Insert function to add a new streak widget above and open the add streak menu
                        )
                      ],
                    )
                )
            ),
            bottomNavigationBar: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(5),
              child: Row(
                  children: [
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                            child: const Text("Calendar"),
                            onPressed: (){} //Insert function to open calendar menu
                        )
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            child: const Text("Settings"),
                            onPressed: (){} //Insert function to open settings menu
                        )
                    ),
                  ]
              )
            )
        )
    );
  }
}*/
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Image(
              image: AssetImage("assets/HappyCat!.png")
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/