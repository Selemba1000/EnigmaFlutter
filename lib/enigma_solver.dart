import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:enigma/enigma.dart';
import 'package:path/path.dart' as p;

class EnigmaSolver{

  EnigmaSolver();

  Solution? output;

  late SendPort mainSend;

  ReceivePort rcv = ReceivePort();

  ReceivePort rco = ReceivePort();

  int workers = Platform.numberOfProcessors;

  String crypt = "";

  var propabilitygrid = [
    0.0648988136775994,
    0.0188415910676902,
    0.0305054331572126,
    0.0506430066792942,
    0.173462266972386,
    0.0165486990329977,
    0.0300069783670621,
    0.0474528960223308,
    0.0752666733127305,
    0.00269165586681288,
    0.0120626059216429,
    0.0342936895623567,
    0.025221812381617,
    0.0974977569534443,
    0.0250224304655568,
    0.00787558568437843,
    0.000199381916060213,
    0.0697836706210747,
    0.0724753264878875,
    0.0613099391885156,
    0.0433655667430964,
    0.00667929418801715,
    0.0188415910676902,
    0.00029907287409032,
    0.000398763832120427,
    0.0112650782574021,];

  Stream bruteforce(String incrypt, {int? overrideworkers, Function? callback}) {
    rcv=ReceivePort();
    rco=ReceivePort();
    crypt = incrypt;
    overrideworkers!=null ? workers = overrideworkers : workers=Platform.numberOfProcessors;
    spawnIsol();
    //Isolate isolate = await Isolate.spawn(mainIsolate, rcv.sendPort);
    return rco;
  }

  void spawnIsol() async {
    await Isolate.spawn(mainIsolate, rcv.sendPort);
    mainSend = await rcv.first;
    mainSend.send(crypt);
    mainSend.send(propabilitygrid);
    mainSend.send(workers);
    mainSend.send(rco.sendPort);
  }

  void kill(){
    mainSend.send(null);
  }


}



Future<void> mainIsolate(SendPort snd) async {

  List<Isolate> isolates = [];
  ReceivePort receiver = ReceivePort();
  var rcstr = StreamQueue(receiver);
  //sleep(Duration(seconds: 1));
  snd.send(receiver.sendPort);

  String crypt = await rcstr.next;
  List<double> propabilitygrid = await rcstr.next;
  int running = await rcstr.next;
  SendPort output = await rcstr.next;

  rcstr.rest.listen((event) {
    if(event==null){
      for(var isolate in isolates){
        isolate.kill();
      }
      Isolate.exit();
    }
  });

  List<Solution> solutions = [];
  int counter = 0;
  int poss = 3*3*3*3*26*26*26;
  List<ReceivePort> rports = List<ReceivePort>.generate(running, (index) => ReceivePort());
  List<StreamQueue> rstr = rports.map((e) => StreamQueue(e)).toList();
  List<SendPort> sports = [];


  for(var i = 0;i<running;i++){
    isolates.add(await Isolate.spawn(workerTask, rports[i].sendPort));
    SendPort sp = await rstr[i].next;
    sports.add(sp);
    sp.send(i);
    sp.send(crypt.substring(0,200));
    sp.send(propabilitygrid);
  }
  var stopwatch = Stopwatch();
  stopwatch.start();
  for (var element in sports) {
    element.send(counter);
    counter++;
  }

  output.send(Update(counter/poss, stopwatch.elapsed,counter));

  var rstrc = StreamQueue(StreamGroup.merge(rstr.map((e) => e.rest)));

  while(solutions.length<poss){
    var get = await rstrc.next as Solution;
      solutions.add(get);
      if(counter<poss) {
        sports[get.workerID].send(counter);
        counter++;
        //print((counter / poss).toString() + '\r');
        if(counter%1000==0) {
          output.send(Update(counter / poss, stopwatch.elapsed, counter));
        }
      }else{
        sports[get.workerID].send(null);
      }
  }

  output.send(Update(counter/poss, stopwatch.elapsed,counter,finishing: true));

  /*
  while(solutions.length<poss){
    for(var i = 0;i<running;i++){
      if(await rstr[i].hasNext){
        var get = await rstr[i].next;
        if(get is Solution){
          solutions.add(get);
          if(counter<poss){
            sports[i].send(counter);
            counter++;
            print((counter/poss).toString()+'\r');
            //output.send(Update(counter/poss, stopwatch.elapsed));
          }else{
            sports[i].send(null);
          }
        }
      }
    }
  }
  */

  for(var port in rports){
    port.close();
  }
  solutions.sort((a,b) => b.score.compareTo(a.score));

  var tmp = solutions.take(10).toList().map((e) {
    int ukw = (e.config%3)+100;
    int w3 = ((e.config/3).round()%3)+1;
    int s3 = (e.config/3/3).round()%26;
    int w2 = ((e.config/3/3/26).round()%3)+1;
    int s2 = (e.config/3/3/26/3).round()%26;
    int w1 = ((e.config/3/3/26/3/26).round()%3)+1;
    int s1 = (e.config/3/3/26/3/26/3).round()%26;
    var enigma = Enigma(w1, s1, w2, s2, w3, s3, ukw);
    var clear = enigma.schluesselnString(crypt);
    return Solution(e.config, clear, e.score, e.workerID);
  }).toList();
  stopwatch.stop();
  output.send(Finish(tmp, stopwatch.elapsed));
  //print(solutions.first.clear);
  //print(solutions.first.score);
  Isolate.exit();
}

void workerTask(SendPort snd) async {
  var filePath = p.join(Directory.current.path, 'assets', 'allpossibilities.txt');
  File file = File(filePath);
  List<String> allstrings = file.readAsLinesSync();
  var rcv = ReceivePort();
  var rcvs = StreamQueue(rcv);
  String crypt;
  List<double> propabilitygrid;
  //sleep(Duration(seconds: 1));
  snd.send(rcv.sendPort);
  int workerID = await rcvs.next;
  crypt = await rcvs.next;
  propabilitygrid = await rcvs.next;
  while(true){
    var get = await rcvs.next;
    if (get is int){
      /*
      int ukw = (get%3)+100;
      int w3 = ((get/3).round()%3)+1;
      int s3 = (get/3/3).round()%26;
      int w2 = ((get/3/3/26).round()%3)+1;
      int s2 = (get/3/3/26/3).round()%26;
      int w1 = ((get/3/3/26/3/26).round()%3)+1;
      int s1 = (get/3/3/26/3/26/3).round()%26;
      var enigma = Enigma(w1, s1, w2, s2, w3, s3, ukw);
      var clear = enigma.schluesselnString(crypt);

       */
      int score = 0;
      for(var i=0;i<crypt.length;i++){
        if(crypt[i]==allstrings[get][i]) score--;
      }
      snd.send(Solution(get, "", score.toDouble(), workerID));
    }else{
      break;
    }
  }
  Isolate.exit();
}

double logdb(num n,num p,num x){
  if(x==0){
    return n*log(1-p);
  }
  return log(sqrt(n))+n*log(n)-log(sqrt(2*pi*x*(n-x)))-x*log(x)-(n-x)*log(n-x)+x*log(p)+(n-x)*log(1-p);
}

class Update{
  double progress;
  Duration time;
  int ops;
  bool finishing;
  Update(this.progress,this.time,this.ops,{this.finishing = false});
}

class Finish{
  List<Solution> solutions;
  Duration time;
  Finish(this.solutions,this.time);
}

abstract class WorkerAnswer{
  int workerID;
  WorkerAnswer(this.workerID);
}

class Solution extends WorkerAnswer{
  int config;
  String clear;
  double score;
  Solution(this.config,this.clear,this.score,int workerID) : super(workerID);
}