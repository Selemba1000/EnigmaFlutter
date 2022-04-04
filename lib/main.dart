import 'package:enigma/enigma_basic_page.dart';
import 'package:enigma/enigma_solver_page.dart';
import 'package:enigma/enigma_gui_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
    darkTheme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: MainMenu(),
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EnigmaGUI()));
                },
                child: Text(
                  "Enigma GUI",
                  style: TextStyle(fontSize: 30),
                ),
                style: ButtonStyle(
                    alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(Size(300, 50))),
              ),
            ),
            kIsWeb ? SizedBox() :
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnigmaSolverPage()));
                },
                child: Text(
                  "Enigma Solver",
                  style: TextStyle(fontSize: 30),
                ),
                style: ButtonStyle(
                    alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(Size(300, 50))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasicEnigma()));
                },
                child: Text(
                  "Enigma Basic",
                  style: TextStyle(fontSize: 30),
                ),
                style: ButtonStyle(
                    alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(Size(300, 50))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BasicEnigma())),
                child: Text("Enigma basic")),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnigmaSolverPage())),
                child: Text("Enigma solve"))
          ],
        ),
      ),
    );
  }
}
