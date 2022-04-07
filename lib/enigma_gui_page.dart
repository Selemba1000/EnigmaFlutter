import 'package:enigma/enigma.dart';
import 'package:flutter/material.dart';

class EnigmaGUI extends StatefulWidget {
  EnigmaGUI({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnigmaGUIState();

  Enigma enigma = Enigma(1, 0, 1, 0, 1, 0, 100);

  List<TasteDaten> tasten = List.generate(26, (index) => TasteDaten(index));
  List<LeuchteDaten> leuchten =
      List.generate(26, (index) => LeuchteDaten(index));

  WalzenConfig config = WalzenConfig(100, 3, 2, 1);

  var notifier = StateUpdate();
}

class _EnigmaGUIState extends State<EnigmaGUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: AnimatedBuilder(
        animation: widget.notifier,
        builder: (context, s) => Container(
          color: Colors.grey[800],
          child: Center(
            child: Focus(
              autofocus: true,
              onKey: (context,event){
                if(event.character!=null){
                  var tmp = charToInt(event.character!);
                  if(tmp.isNotEmpty){
                    var out = widget.enigma.schluesselnChar(tmp.first);
                    for(var leuchte in widget.leuchten){
                      leuchte.leuchtet=false;
                    }
                    widget.leuchten[out].leuchtet=true;
                    widget.notifier.set();
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: walzenFeld(
                        widget.enigma, widget.config, widget.notifier),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: leuchtFeld(widget.leuchten, widget.notifier),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: tastFeld(widget.tasten, widget.notifier,
                        widget.enigma, widget.leuchten),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(child: Text("Zurück", style: TextStyle(fontSize: 25)),padding: EdgeInsets.all(5),),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

List<String> uoptions = ["A", "B", "C"];
List<String> woptions = ["I", "II", "III"];

double w3p = 0;
int w3s = 0;
double w2p = 0;
int w2s = 0;
double w1p = 0;
int w1s = 0;

Widget walzenFeld(Enigma enigma, WalzenConfig config, StateUpdate update) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.black,
          width: 2,
        )),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        //UKW
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            value: config.ukw,
            alignment: AlignmentDirectional.centerEnd,
            decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 50)),
            items: uoptions
                .map((e) => DropdownMenuItem(
                    value: charToInt(e).first + 100,
                    child: Center(
                      child: Text(e),
                    )))
                .toList(),
            onChanged: (value) {
              config.ukw = value as int;
              enigma.umkehrwalze = Walze(0, value);
              update.set();
            },
            selectedItemBuilder: (context) {
              return uoptions.map((name) {
                return Container(
                  child: Text(
                    name,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: 25,
                  alignment: Alignment.bottomRight,
                );
              }).toList();
            },
          ),
        ),
        //W3
        SizedBox(
          width: 170,
          height: 200,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 200,
                      child: Image.asset(
                        "img/WalzeCounter.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      intToChar(enigma.walzen[2].position),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  child: GestureDetector(
                    onVerticalDragStart: (details) {
                      w3s = enigma.walzen[2].position;
                    },
                    onVerticalDragUpdate: (details) {
                      w3p += details.delta.dy;
                      enigma.walzen[2].position = ((w3p / 15).round()) % 26;
                      update.set();
                    },
                    onVerticalDragEnd: (details) {
                      w3p = 0;
                    },
                    child: Image.asset(
                      "img/WalzeFinal.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 50,
                  height: 200,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            value: config.w3,
            alignment: AlignmentDirectional.centerEnd,
            decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 50)),
            items: woptions
                .map((e) => DropdownMenuItem(
                    value: woptions.indexOf(e) + 1,
                    child: Center(
                      child: Text(e),
                    )))
                .toList(),
            onChanged: (value) {
              config.w3 = value as int;
              enigma.walzen[2] = Walze(0, value);
              update.set();
            },
            selectedItemBuilder: (context) {
              return woptions.map((name) {
                return Container(
                  child: Text(
                    name,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: 25,
                  alignment: Alignment.bottomRight,
                );
              }).toList();
            },
          ),
        ),
        //W2
        SizedBox(
          width: 170,
          height: 200,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 200,
                      child: Image.asset(
                        "img/WalzeCounter.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      intToChar(enigma.walzen[1].position),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  child: GestureDetector(
                    onVerticalDragStart: (details) {
                      w2s = enigma.walzen[1].position;
                    },
                    onVerticalDragUpdate: (details) {
                      w2p += details.delta.dy;
                      enigma.walzen[1].position = ((w2p / 15).round()) % 26;
                      update.set();
                    },
                    onVerticalDragEnd: (details) {
                      w2p = 0;
                    },
                    child: Image.asset(
                      "img/WalzeFinal.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 50,
                  height: 200,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            value: config.w2,
            alignment: AlignmentDirectional.centerEnd,
            decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 50)),
            items: woptions
                .map((e) => DropdownMenuItem(
                    value: woptions.indexOf(e) + 1,
                    child: Center(
                      child: Text(e),
                    )))
                .toList(),
            onChanged: (value) {
              config.w2 = value as int;
              enigma.walzen[1] = Walze(0, value);
              update.set();
            },
            selectedItemBuilder: (context) {
              return woptions.map((name) {
                return Container(
                  child: Text(
                    name,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: 25,
                  alignment: Alignment.bottomRight,
                );
              }).toList();
            },
          ),
        ),
        //W1
        SizedBox(
          width: 170,
          height: 200,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 200,
                      child: Image.asset(
                        "img/WalzeCounter.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      intToChar(enigma.walzen[0].position),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  child: GestureDetector(
                    onVerticalDragStart: (details) {
                      w1s = enigma.walzen[0].position;
                    },
                    onVerticalDragUpdate: (details) {
                      w1p += details.delta.dy;
                      enigma.walzen[0].position = ((w1p / 15).round()) % 26;
                      update.set();
                    },
                    onVerticalDragEnd: (details) {
                      w1p = 0;
                    },
                    child: Image.asset(
                      "img/WalzeFinal.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 50,
                  height: 200,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            value: config.w1,
            alignment: AlignmentDirectional.centerEnd,
            decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 50)),
            items: woptions
                .map((e) => DropdownMenuItem(
                    value: woptions.indexOf(e) + 1,
                    child: Center(
                      child: Text(e),
                    )))
                .toList(),
            onChanged: (value) {
              config.w1 = value as int;
              enigma.walzen[0] = Walze(0, value);
              update.set();
            },
            selectedItemBuilder: (context) {
              return woptions.map((name) {
                return Container(
                  child: Text(
                    name,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: 25,
                  alignment: Alignment.bottomRight,
                );
              }).toList();
            },
          ),
        ),
      ],
    ),
  );
}

Widget leuchtFeld(List<LeuchteDaten> leuchten, StateUpdate update) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.black,
          width: 2,
        )),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            leuchte(leuchten[charToInt("Q").first], update),
            leuchte(leuchten[charToInt("W").first], update),
            leuchte(leuchten[charToInt("E").first], update),
            leuchte(leuchten[charToInt("R").first], update),
            leuchte(leuchten[charToInt("T").first], update),
            leuchte(leuchten[charToInt("Z").first], update),
            leuchte(leuchten[charToInt("U").first], update),
            leuchte(leuchten[charToInt("I").first], update),
            leuchte(leuchten[charToInt("O").first], update),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.only(left: 50)),
            leuchte(leuchten[charToInt("A").first], update),
            leuchte(leuchten[charToInt("S").first], update),
            leuchte(leuchten[charToInt("D").first], update),
            leuchte(leuchten[charToInt("F").first], update),
            leuchte(leuchten[charToInt("G").first], update),
            leuchte(leuchten[charToInt("H").first], update),
            leuchte(leuchten[charToInt("J").first], update),
            leuchte(leuchten[charToInt("K").first], update),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            leuchte(leuchten[charToInt("P").first], update),
            leuchte(leuchten[charToInt("Y").first], update),
            leuchte(leuchten[charToInt("X").first], update),
            leuchte(leuchten[charToInt("C").first], update),
            leuchte(leuchten[charToInt("V").first], update),
            leuchte(leuchten[charToInt("B").first], update),
            leuchte(leuchten[charToInt("N").first], update),
            leuchte(leuchten[charToInt("M").first], update),
            leuchte(leuchten[charToInt("L").first], update),
          ],
        ),
      ],
    ),
  );
}

Widget tastFeld(List<TasteDaten> tasten, StateUpdate update, Enigma enigma,
    List<LeuchteDaten> leuchten) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.black,
          width: 2,
        )),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            taste(tasten[charToInt("Q").first], update, enigma, leuchten),
            taste(tasten[charToInt("W").first], update, enigma, leuchten),
            taste(tasten[charToInt("E").first], update, enigma, leuchten),
            taste(tasten[charToInt("R").first], update, enigma, leuchten),
            taste(tasten[charToInt("T").first], update, enigma, leuchten),
            taste(tasten[charToInt("Z").first], update, enigma, leuchten),
            taste(tasten[charToInt("U").first], update, enigma, leuchten),
            taste(tasten[charToInt("I").first], update, enigma, leuchten),
            taste(tasten[charToInt("O").first], update, enigma, leuchten),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.only(left: 50)),
            taste(tasten[charToInt("A").first], update, enigma, leuchten),
            taste(tasten[charToInt("S").first], update, enigma, leuchten),
            taste(tasten[charToInt("D").first], update, enigma, leuchten),
            taste(tasten[charToInt("F").first], update, enigma, leuchten),
            taste(tasten[charToInt("G").first], update, enigma, leuchten),
            taste(tasten[charToInt("H").first], update, enigma, leuchten),
            taste(tasten[charToInt("J").first], update, enigma, leuchten),
            taste(tasten[charToInt("K").first], update, enigma, leuchten),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            taste(tasten[charToInt("P").first], update, enigma, leuchten),
            taste(tasten[charToInt("Y").first], update, enigma, leuchten),
            taste(tasten[charToInt("X").first], update, enigma, leuchten),
            taste(tasten[charToInt("C").first], update, enigma, leuchten),
            taste(tasten[charToInt("V").first], update, enigma, leuchten),
            taste(tasten[charToInt("B").first], update, enigma, leuchten),
            taste(tasten[charToInt("N").first], update, enigma, leuchten),
            taste(tasten[charToInt("M").first], update, enigma, leuchten),
            taste(tasten[charToInt("L").first], update, enigma, leuchten),
          ],
        ),
      ],
    ),
  );
}

class StateUpdate extends ChangeNotifier {
  void set() {
    notifyListeners();
  }
}

Widget taste(TasteDaten taste, StateUpdate update, Enigma enigma,
    List<LeuchteDaten> leuchten) {
  return SizedBox(
    width: 100,
    height: 100,
    child: GestureDetector(
      onTapDown: (details) {
        taste.unten = true;
        for (var element in leuchten) {
          element.leuchtet = false;
        }
        update.set();
      },
      onTapUp: (details) {
        taste.unten = false;
        var tmp = enigma.schluesselnChar(taste.id);
        leuchten[tmp].leuchtet = true;
        update.set();
      },
      onTapCancel: () {
        taste.unten = false;
        update.set();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "img/ButtonPress.png",
            color: taste.unten
                ? const Color.fromRGBO(0, 0, 0, .7)
                : const Color.fromRGBO(0, 0, 0, .9999),
            colorBlendMode: BlendMode.dstIn,
          ),
          Text(
            intToChar(taste.id),
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      ),
    ),
  );
}

Widget leuchte(LeuchteDaten leuchte, StateUpdate update) {
  return SizedBox(
    height: 100,
    width: 100,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "img/ButtonLight.png",
        ),
        Container(
          width: 76.1616,
          height: 76.1616,
          decoration: new BoxDecoration(
            color: leuchte.leuchtet
                ? const Color.fromRGBO(255, 255, 0, 0.75)
                : const Color.fromRGBO(255, 255, 0, 0),
            shape: BoxShape.circle,
          ),),
        Text(
          intToChar(leuchte.id),
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ],
    ),
  );
}

class WalzenConfig {
  int ukw;
  int w1, w2, w3;

  WalzenConfig(this.ukw, this.w3, this.w2, this.w1);
}

class LeuchteDaten {
  int id;
  String char = "";
  bool leuchtet = false;

  LeuchteDaten(this.id) {
    char = intToChar(id);
  }
}

class TasteDaten {
  int id;
  bool unten = false;
  String char = "";

  TasteDaten(this.id) {
    char = intToChar(id);
  }
}
