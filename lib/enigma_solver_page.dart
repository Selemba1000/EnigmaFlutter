import 'package:enigma/enigma.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'enigma_solver.dart';

class EnigmaSolverPage extends StatefulWidget {
  EnigmaSolverPage({Key? key}) : super(key: key);

  Inputs input = Inputs("");
  TriState notifier = TriState();

  @override
  State<StatefulWidget> createState() => _EnigmaSolverPageState();
}

class _EnigmaSolverPageState extends State<EnigmaSolverPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 50000,
        height: 50000,
        child: AnimatedBuilder(
            animation: widget.notifier,
            builder: (context, child) {
              return Center(
                  child: widget.notifier.computing
                      ? LoadingWidget(widget.input, widget.notifier)
                      : InputFields(widget.input, widget.notifier));
            }),
      ),
    );
  }
}

class TriState extends ChangeNotifier {
  bool computing = false;

  void set() {
    if (computing == false) computing = true;
    notifyListeners();
  }

  void reset() {
    computing = false;
    notifyListeners();
  }
}

class Inputs {
  String input;
  int? threads;

  Inputs(this.input, {this.threads});
}

class InputFields extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InputFieldsState();

  Inputs input;
  TriState notifier;

  InputFields(this.input, this.notifier);
}

class _InputFieldsState extends State<InputFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 500,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Brute Force Enigma I",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100, maxWidth: 500),
              child: TextField(
                onChanged: (value) {
                  widget.input.input = value;
                },
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Verschlüsselter String:"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100, maxWidth: 500),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Threads: (leer für Standard)"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    if (widget.input.input.isNotEmpty) {
                      widget.notifier.set();
                    }
                  },
                  child: const Text("Entschlüsseln"))),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Zurück")))
        ],
      ),
    );
  }
}

class LoadingWidget extends StatefulWidget {
  Inputs input;
  TriState triState;

  LoadingWidget(this.input, this.triState);

  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late Stream stream;
  late EnigmaSolver solver;

  int page = 0;

  @override
  void initState() {
    //stream=Stream.empty();
    solver = EnigmaSolver();
    stream = solver.bruteforce(widget.input.input,
        overrideworkers: widget.input.threads);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 500,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data is Update) {
            final data = snapshot.data as Update;
            if (data.finishing) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Fortschritt",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LinearProgressIndicator(
                      value: 0,
                      minHeight: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: Text((0).toStringAsFixed(1) + "%"),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: Text(((0 / data.time.inSeconds))
                                .toStringAsFixed(0) +
                            "ops/s"),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: Text(((0) *
                                    (1 - 0))
                                .toStringAsFixed(1) +
                            "s"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          solver.kill();
                          widget.triState.reset();
                        },
                        child: const Text("Abbrechen")),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data as Finish;
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Ergebnis",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                      text: data.solutions[(page)].clear),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                              page = (page - 1) % 10;
                            }),
                        icon: const Icon(Icons.navigate_before)),
                    Text((page+1).toString() + "/10"),
                    IconButton(
                        onPressed: () => setState(() {
                          page = (page + 1) % 10;
                        }),
                        icon: const Icon(Icons.navigate_next)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Benötigte Zeit: "+data.time.inMilliseconds.toStringAsFixed(0)+"ms"),
                    Text("Konfiguration: "+getConfig(data.solutions[page].config)),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () => widget.triState.reset(),
                      child: const Text("Zurück")))
            ],
          ));
        },
      ),
    );
  }
}

String getConfig(int config){
  int ukw = (config%3);
  int w3 = ((config/78).floor()%3)+1;
  int s3 = (config/3).floor()%26;
  int w2 = ((config/6084).floor()%3)+1;
  int s2 = (config/234).floor()%26;
  int w1 = ((config/474551).floor()%3)+1;
  int s1 = (config/18252).floor()%26;
  return w1.toString()+" \\/ "+intToChar(s1)+" | "+w2.toString()+" \\/ "+intToChar(s2)+" | "+w3.toString()+" \\/ "+intToChar(s3)+" | "+intToChar(ukw);
}
