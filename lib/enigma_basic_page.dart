import 'package:enigma/enigma.dart';
import 'package:flutter/material.dart';

class BasicEnigma extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BasicEnigmaSate();
}

class _BasicEnigmaSate extends State<BasicEnigma> {
  String output = "";
  String input = "";
  int w1 = 0;
  int s1 = 0;
  int w2 = 0;
  int s2 = 0;
  int w3 = 0;
  int s3 = 0;
  int ukw = 0;

  List<String> uoptions = ["A", "B", "C"];
  List<String> woptions = ["I", "II", "III"];
  List<String> soptions = List<String>.generate(26, (int index) {
    return String.fromCharCode(index + 65);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Enigma I",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              Form(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 5),
                      //color: Colors.green[200]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: TextFormField(
                                    onChanged: (value) => input = value,
                                    maxLines: null,
                                    onSaved: (value) {
                                      input = value ?? "";
                                      var enigma = Enigma(w1 + 1, s1, w2 + 1,
                                          s2, w3 + 1, s3, ukw + 100);
                                      output = enigma.schluesselnString(input);
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Text zum verschlüsseln",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Walze 1
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Walze 1",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonFormField<int>(
                                    value: w1,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: woptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: woptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return woptions.map((name) {
                                        return Container(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        w1 = value!;
                                      });
                                    }),
                                DropdownButtonFormField<int>(
                                    value: s1,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: soptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: soptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return soptions.map((name) {
                                        return Container(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        s1 = value!;
                                      });
                                    }),
                              ]),
                        ),
                        //Walze 2
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Walze 2",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonFormField<int>(
                                    value: w2,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: woptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: woptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return woptions.map((name) {
                                        return Container(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        w2 = value!;
                                      });
                                    }),
                                DropdownButtonFormField<int>(
                                    value: s2,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: soptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: soptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return soptions.map((name) {
                                        return SizedBox(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        s2 = value!;
                                      });
                                    }),
                              ]),
                        ),
                        //Walze 3
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Walze 3",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonFormField<int>(
                                    value: w3,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: woptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: woptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return woptions.map((name) {
                                        return SizedBox(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        w3 = value!;
                                      });
                                    }),
                                DropdownButtonFormField<int>(
                                    value: s3,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: soptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: soptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return soptions.map((name) {
                                        return SizedBox(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        s3 = value!;
                                      });
                                    }),
                              ]),
                        ),
                        //UmkehrWalze
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Umkehrwalze",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonFormField<int>(
                                    value: ukw,
                                    alignment: AlignmentDirectional.centerEnd,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 100)),
                                    items: uoptions.map((String name) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(name),
                                        ),
                                        value: uoptions.indexOf(name),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (context) {
                                      return uoptions.map((name) {
                                        return SizedBox(
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.end,
                                          ),
                                          width: 50,
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        ukw = value!;
                                      });
                                    }),
                              ]),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: TextEditingController(
                                      text: output,
                                    ),
                                    //enabled: false,
                                    decoration: const InputDecoration(
                                        constraints:
                                            BoxConstraints(maxWidth: 500)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {
                        var enigma = Enigma(
                            w1 + 1, s1, w2 + 1, s2, w3 + 1, s3, ukw + 100);
                        output = enigma.schluesselnString(input);
                        setState(() {});
                      },
                      child: const Text("Verschlüsseln"))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Zurück"))),
            ],
          ),
        ),
      ),
    );
  }
}
