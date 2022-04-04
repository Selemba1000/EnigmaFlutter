import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'enigma.dart';

class EnigmaGui extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EnigmaGuiSate();

  Enigma enigma = Enigma(1,0,1,0,1,0,100);

  List<bool> leuchten = List.generate(26, (index) => false);

}

class _EnigmaGuiSate extends State<EnigmaGui>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.grey[800]
      ),
      debugShowCheckedModeBanner: false,
      home: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("W").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("W",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("E").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("E",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("R").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("R",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("T").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("T",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("Z").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("Z",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("U").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("U",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("I").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("I",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("O").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("O",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),


          ],
        ),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left:50)),
            MaterialButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: (){
                widget.leuchten.replaceRange(0,25,List.generate(26, (index) => false));
                var tmp = widget.enigma.schluesselnChar(charToInt("Q").first);
                widget.leuchten[tmp]=true;
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("lib/assets/img/ButtonPress.png"),fit: BoxFit.cover),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: Text("Q",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)),
                ),
              ),
            ),
          ],
        ),
        Row(),
      ],
      ),
    );
  }

}